import 'dart:async';

import 'package:get/get.dart';
import 'package:labplus_for_gitlab/api/api.dart';
import 'package:labplus_for_gitlab/models/models.dart';
import 'package:labplus_for_gitlab/routes/routes.dart';
import 'package:labplus_for_gitlab/shared/shared.dart';

typedef HttpFunction = Future<void> Function();

enum HttpState { loading, error, empty, ok, tokenExpired }

mixin HttpController {
  var state = HttpState.loading.obs;

  /// Runs [function], mapping any [ApiError] it surfaces onto the loading and
  /// error state this mixin exposes.
  ///
  /// Failures used to arrive as a raw `DioException` thrown from deep inside
  /// Dio's interceptor chain. `ApiRepository` now absorbs those and returns a
  /// [Failure]; controllers turn one back into a throw at the point they stop
  /// caring, via [ApiResult.unwrap]. So the type caught here is [ApiException],
  /// and the branch conditions read a typed [ApiError] rather than digging
  /// through `e.response?.statusCode`.
  Future<int> runWithErrorHandling(HttpFunction function) async {
    try {
      state.value = HttpState.loading;
      await function();
      state.value = HttpState.ok;
      return 0;
    } on ApiException catch (e) {
      return _handleFailure(e.error, function, withState: true);
    }
  }

  Future<int> runWithErrorHandlingWithoutState(HttpFunction function) async {
    try {
      await function();
      return 0;
    } on ApiException catch (e) {
      return _handleFailure(e.error, function, withState: false);
    }
  }

  Future<int> _handleFailure(
    ApiError error,
    HttpFunction function, {
    required bool withState,
  }) {
    if (error.isUnauthorized) {
      state.value = HttpState.tokenExpired;
      return handleTokenExiration(function);
    }

    if (withState && error.isForbidden) {
      CommonWidget.toast('Forbidden');
      state.value = HttpState.error;
      return Future.value(0);
    }

    if (withState) {
      state.value = HttpState.error;
    }

    // A transport failure has no status code. It used to collapse to 0, which
    // handleHttpActionState reads as success -- so a timeout looked like it
    // had worked. -1 keeps it distinguishable.
    return Future.value(error.statusCode ?? -1);
  }

  handleHttpActionState(int code) {
    if (code == 0) {
      state.value = HttpState.ok;
      return;
    }

    if (code == 401) {
      handleTokenExiration(null);

      state.value = HttpState.tokenExpired;
    } else if (code == 403) {
      state.value = HttpState.error;
      CommonWidget.toast('Forbidden');
    } else {
      state.value = HttpState.error;
      CommonWidget.toast(CommonConstants.errorMessage);
    }
  }

  handleHttpActionWithoutState(int code) {
    if (code == 0) {
      return;
    }

    if (code == 401) {
      state.value = HttpState.tokenExpired;

      handleTokenExiration(null);

      return 0;
    }

    if (code == 403) {
      CommonWidget.toast('Forbidden');
    } else {
      CommonWidget.toast(CommonConstants.errorMessage);
    }
  }

  /// In-flight token refresh, shared across every controller.
  ///
  /// Without this, four parallel requests failing 401 at once each started
  /// their own refresh. GitLab rotates the refresh token on use, so the first
  /// call invalidated the token the other three were still holding and the
  /// user got silently signed out. Everyone now awaits the same future.
  static Future<int>? _refreshInFlight;

  Future<int> handleTokenExiration(HttpFunction? function) async {
    final refresh = _refreshInFlight ??= _refreshToken();

    int result;
    try {
      result = await refresh;
    } finally {
      if (identical(_refreshInFlight, refresh)) {
        _refreshInFlight = null;
      }
    }

    // Retried outside the shared refresh so that concurrent callers each replay
    // their own request once the single refresh has settled.
    if (result == 0 && function != null) {
      await function();
    }
    return result;
  }

  Future<int> _refreshToken() async {
    var repository = Get.find<ApiRepository>();
    var sstorage = Get.find<SecureStorage>();

    var acc = sstorage.getDefaultAccount();

    if (acc == null || acc.refreshToken == null || acc.refreshToken == "") {
      _requireReauthorization();
      return 401;
    }

    try {
      final result = await repository.refreshToken(RefreshTokenRequest(
          grantType: 'refresh_token', refreshToken: acc.refreshToken!));

      // Every way this can fail is now one value. It used to be
      // `res!.accessToken` on a method that returned null for any non-200,
      // inside a try that only caught DioException -- so a 400-with-a-body,
      // exactly the failure this path exists to handle, crashed with an
      // unhandled null-check error.
      if (result is! Ok<AccessTokenResponse> ||
          result.value.accessToken == null) {
        _requireReauthorization();
        return 401;
      }

      final res = result.value;
      acc.accessToken = res.accessToken;
      acc.refreshToken = res.refreshToken;

      // Previously fire-and-forget: the rotated credential could still be
      // unwritten when the next request read it back.
      await sstorage.addUpdateAccount(acc);

      sstorage.setToken(acc.accessToken!);

      CommonWidget.toast('Your access token has been renewed.');

      return 0;
    } on ApiException {
      _requireReauthorization();
      return 401;
    }
  }

  void _requireReauthorization() {
    Get.toNamed(Routes.auth);
    CommonWidget.toast('Please re-authorize your token.');
  }
}

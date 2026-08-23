import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:labplus_for_gitlab/api/api.dart';
import 'package:labplus_for_gitlab/models/models.dart';
import 'package:labplus_for_gitlab/routes/routes.dart';
import 'package:labplus_for_gitlab/shared/shared.dart';

typedef HttpFunction = Future<void> Function();

enum HttpState { loading, error, empty, ok, tokenExpired }

mixin HttpController {
  var state = HttpState.loading.obs;

  Future<int> runWithErrorHandling(HttpFunction function) async {
    try {
      state.value = HttpState.loading;
      await function();
      state.value = HttpState.ok;
      return 0;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        state.value = HttpState.tokenExpired;
        return handleTokenExiration(function);
      }
      if (e.response?.statusCode == 403) {
        CommonWidget.toast('Forbidden');
        state.value = HttpState.error;
        return 0;
      }

      state.value = HttpState.error;

      return e.response?.statusCode ?? 0;
    }
  }

  Future<int> runWithErrorHandlingWithoutState(HttpFunction function) async {
    // handleTokenExiration();

    try {
      await function();
      return 0;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        state.value = HttpState.tokenExpired;
        return handleTokenExiration(function);
      }

      return e.response?.statusCode ?? 0;
    }
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
      var res = await repository.refreshToken(RefreshTokenRequest(
          grantType: 'refresh_token', refreshToken: acc.refreshToken!));

      // refreshToken() returns null on any non-200. This used to be
      // `res!.accessToken`, and the surrounding catch only handles
      // DioException, so a 400-with-a-body -- exactly the failure this path
      // exists to handle -- crashed with an unhandled null-check error.
      if (res == null || res.accessToken == null) {
        _requireReauthorization();
        return 401;
      }

      acc.accessToken = res.accessToken;
      acc.refreshToken = res.refreshToken;

      // Previously fire-and-forget: the rotated credential could still be
      // unwritten when the next request read it back.
      await sstorage.addUpdateAccount(acc);

      sstorage.setToken(acc.accessToken!);

      CommonWidget.toast('Your access token has been renewed.');

      return 0;
    } on DioException {
      _requireReauthorization();
      return 401;
    }
  }

  void _requireReauthorization() {
    Get.toNamed(Routes.auth);
    CommonWidget.toast('Please re-authorize your token.');
  }
}

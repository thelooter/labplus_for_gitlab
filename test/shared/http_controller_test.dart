import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:labplus_for_gitlab/api/api.dart';
import 'package:labplus_for_gitlab/models/models.dart';
import 'package:labplus_for_gitlab/shared/shared.dart';

import '../support/fakes.dart';

/// An `ApiRepository` whose token refresh the test drives.
///
/// [gate] lets a test hold every refresh open at once, which is the only way
/// to observe whether concurrent callers share one in-flight call.
class GatedApiRepository extends ApiRepository {
  GatedApiRepository({required super.apiProvider});

  int refreshCalls = 0;
  Completer<void>? gate;
  ApiResult<AccessTokenResponse> result = Ok(AccessTokenResponse(
    accessToken: 'new-access',
    refreshToken: 'new-refresh',
    tokenType: 'bearer',
    scope: 'api',
    createdAt: 0,
    idToken: null,
  ));

  @override
  Future<ApiResult<AccessTokenResponse>> refreshToken(
      RefreshTokenRequest data) async {
    refreshCalls++;
    if (gate != null) await gate!.future;
    return result;
  }
}

class _Subject with HttpController {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late GatedApiRepository api;
  late FakeSecureStorage storage;

  setUp(() {
    Get.reset();
    // Must come after reset(): reset() clears it, and the reauthorization path
    // calls Get.toNamed(Routes.auth), which otherwise demands a GetMaterialApp.
    Get.testMode = true;

    // CommonWidget.toast reaches for the fluttertoast platform channel, which
    // has no implementation under `flutter test`.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('PonnamKarthik/fluttertoast'),
      (_) async => true,
    );

    storage = FakeSecureStorage()
      ..defaultAccount = AppAccount(
        userId: 1,
        accessToken: 'old-access',
        refreshToken: 'old-refresh',
        baseUrl: 'https://gitlab.example',
      );
    api = GatedApiRepository(
      apiProvider: ApiProvider(storage: storage, dio: Dio()),
    );

    Get.put<SecureStorage>(storage);
    Get.put<ApiRepository>(api);
  });

  tearDown(Get.reset);

  group('concurrent refresh', () {
    // GitLab rotates the refresh token on use. Without a shared in-flight
    // future, four parallel 401s each started their own refresh: the first
    // invalidated the token the other three were still holding, and the user
    // was silently signed out.
    test('four simultaneous 401s trigger exactly one refresh', () async {
      api.gate = Completer<void>();

      final callers = List.generate(4, (_) => _Subject().handleTokenExiration(null));
      await pumpEventQueue();

      expect(api.refreshCalls, 1, reason: 'the other three await the first');

      api.gate!.complete();
      final results = await Future.wait(callers);

      expect(api.refreshCalls, 1);
      expect(results, everyElement(0));
    });

    test('every concurrent caller replays its own request', () async {
      api.gate = Completer<void>();
      var replays = 0;
      Future<void> replay() async => replays++;

      final callers =
          List.generate(3, (_) => _Subject().handleTokenExiration(replay));
      await pumpEventQueue();
      api.gate!.complete();
      await Future.wait(callers);

      expect(replays, 3, reason: 'the refresh is shared, the retry is not');
    });

    test('a later 401 starts a fresh refresh once the first has settled',
        () async {
      await _Subject().handleTokenExiration(null);
      await _Subject().handleTokenExiration(null);

      expect(api.refreshCalls, 2, reason: 'the in-flight future is released');
    });
  });

  group('refresh failure', () {
    // This used to be `acc.accessToken = res!.accessToken` on a method that
    // returned null for any non-200, inside a try that only caught
    // DioException. A 400-with-a-body -- the exact failure this path exists to
    // handle -- crashed with an unhandled null-check error.
    test('a failed refresh returns 401 instead of throwing', () async {
      api.result = const Failure(ApiError(statusCode: 400));

      await expectLater(_Subject().handleTokenExiration(null), completion(401));
    });

    test('a 2xx refresh with no access token returns 401 instead of throwing',
        () async {
      api.result = Ok(AccessTokenResponse(
        accessToken: null,
        refreshToken: null,
        tokenType: null,
        scope: null,
        createdAt: null,
        idToken: null,
      ));

      await expectLater(_Subject().handleTokenExiration(null), completion(401));
    });

    test('a failed refresh does not replay the caller request', () async {
      api.result = const Failure(ApiError(statusCode: 400));
      var replays = 0;

      await _Subject().handleTokenExiration(() async => replays++);

      expect(replays, 0);
    });

    test('no refresh is attempted when there is no stored account', () async {
      storage.defaultAccount = null;

      final result = await _Subject().handleTokenExiration(null);

      expect(result, 401);
      expect(api.refreshCalls, 0);
    });

    test('a failure releases the in-flight future for the next attempt',
        () async {
      api.result = const Failure(ApiError(statusCode: 400));
      await _Subject().handleTokenExiration(null);
      await _Subject().handleTokenExiration(null);

      expect(api.refreshCalls, 2);
    });
  });

  group('refresh success', () {
    test('persists the rotated credential before returning', () async {
      await _Subject().handleTokenExiration(null);

      // addUpdateAccount used to be fire-and-forget, so the next request could
      // read back the credential that had just been replaced.
      expect(storage.saved, hasLength(1));
      expect(storage.saved.single.accessToken, 'new-access');
      expect(storage.saved.single.refreshToken, 'new-refresh');
    });

    test('installs the new access token for subsequent requests', () async {
      await _Subject().handleTokenExiration(null);

      expect(storage.getToken(), 'new-access');
    });
  });
}

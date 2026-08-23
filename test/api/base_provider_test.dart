import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:labplus_for_gitlab/api/api.dart';

import '../support/fakes.dart';

/// These are the first tests this repository has ever had.
///
/// They are possible only because `BaseProvider` now takes its `SecureStorage`,
/// its `Dio` and its `ApiObserver` as constructor arguments. Before that it
/// called `Get.find<SecureStorage>()` and `EasyLoading.dismiss()` directly, so
/// building one required a live GetX container and a Flutter binding.
void main() {
  late FakeSecureStorage storage;
  late RecordingApiObserver observer;

  setUp(() {
    storage = FakeSecureStorage();
    observer = RecordingApiObserver();
  });

  ApiProvider providerWith(FakeHttpAdapter adapter) {
    final dio = Dio()..httpClientAdapter = adapter;
    return ApiProvider(storage: storage, observer: observer, dio: dio);
  }

  group('request interceptor', () {
    test('attaches the bearer token when one is stored', () async {
      storage.token = 'abc123';
      final adapter = FakeHttpAdapter((_) => (status: 200, body: {}));

      await providerWith(adapter).getUser('/api/v4/user');

      expect(adapter.requests.single.headers['Authorization'],
          'Bearer abc123');
    });

    test('omits the Authorization header when no token is stored', () async {
      storage.token = '';
      final adapter = FakeHttpAdapter((_) => (status: 200, body: {}));

      await providerWith(adapter).getUser('/api/v4/user');

      expect(adapter.requests.single.headers.containsKey('Authorization'),
          isFalse);
    });

    test('resolves the base url from storage at request time', () async {
      storage.baseUrl = 'https://gitlab.example.org';
      final adapter = FakeHttpAdapter((_) => (status: 200, body: {}));

      await providerWith(adapter).getUser('/api/v4/user');

      expect(adapter.requests.single.uri.toString(),
          'https://gitlab.example.org/api/v4/user');
    });

    test('picks up a base url changed between requests', () async {
      final adapter = FakeHttpAdapter((_) => (status: 200, body: {}));
      final provider = providerWith(adapter);

      storage.baseUrl = 'https://one.example';
      await provider.getUser('/api/v4/user');
      storage.baseUrl = 'https://two.example';
      await provider.getUser('/api/v4/user');

      expect(adapter.requests.map((r) => r.uri.host),
          ['one.example', 'two.example']);
    });
  });

  group('observer', () {
    test('is notified when a request succeeds', () async {
      final adapter = FakeHttpAdapter((_) => (status: 200, body: {}));

      await providerWith(adapter).getUser('/api/v4/user');

      expect(observer.settled, 1);
    });

    test('is notified when a request fails', () async {
      final adapter = FakeHttpAdapter((_) => (status: 500, body: {}));

      await expectLater(
        providerWith(adapter).getUser('/api/v4/user'),
        throwsA(isA<DioException>()),
      );

      expect(observer.settled, 1);
    });

    test('is optional, so the tier works with no UI attached', () async {
      final adapter = FakeHttpAdapter((_) => (status: 200, body: {}));
      final dio = Dio()..httpClientAdapter = adapter;
      final provider = ApiProvider(storage: storage, dio: dio);

      await expectLater(provider.getUser('/api/v4/user'), completes);
    });
  });

  group('error routing', () {
    // The old onResponse interceptor toasted "An error occured" for any status
    // outside [200, 201, 202, 204]. It could never fire: Dio's default
    // validateStatus sends every non-2xx to onError first. This pins that.
    test('a non-2xx response reaches onError rather than onResponse', () async {
      final adapter = FakeHttpAdapter((_) => (status: 403, body: {}));

      await expectLater(
        providerWith(adapter).getUser('/api/v4/user'),
        throwsA(isA<DioException>().having(
          (e) => e.response?.statusCode,
          'statusCode',
          403,
        )),
      );
    });
  });
}

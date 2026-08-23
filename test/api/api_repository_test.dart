import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:labplus_for_gitlab/api/api.dart';
import 'package:labplus_for_gitlab/models/models.dart';

import '../support/fakes.dart';

void main() {
  late FakeSecureStorage storage;

  setUp(() => storage = FakeSecureStorage());

  ApiRepository repositoryThat(
    ({int status, Object? body}) Function(RequestOptions) respond, {
    Map<String, List<String>> headers = const {},
  }) {
    final dio = Dio()
      ..httpClientAdapter = FakeHttpAdapter(respond, headers: headers);
    return ApiRepository(apiProvider: ApiProvider(storage: storage, dio: dio));
  }

  group('success', () {
    test('a 200 with a body becomes Ok', () async {
      final repo = repositoryThat((_) => (
            status: 200,
            body: {'id': 7, 'username': 'thelooter'},
          ));

      final result = await repo.getUser();

      expect(result, isA<Ok<User>>());
      expect((result as Ok<User>).value.id, 7);
    });

    // The old bodies guarded on `res.statusCode == 200` and returned null
    // otherwise. Dio only ever lets 2xx reach them, so the only codes that
    // guard could reject were 201 Created and 204 No Content -- exactly what
    // GitLab returns from its create and delete endpoints.
    test('a 201 Created is a success, not a failure', () async {
      final repo = repositoryThat((_) => (status: 201, body: {}));

      final result = await repo.createProject(CreateProjectRequest(name: 'x'));

      expect(result, isA<Ok<void>>());
    });

    test('a 204 No Content is a success, not a failure', () async {
      final repo = repositoryThat((_) => (status: 204, body: {}));

      final result = await repo.deleteProjectLabel(1, 2);

      expect(result, isA<Ok<void>>());
    });

    test('a paging response carries its pagination headers', () async {
      final repo = repositoryThat(
        (_) => (
          status: 200,
          body: [
            {'id': 1, 'title': 'first'},
            {'id': 2, 'title': 'second'},
          ]
        ),
        headers: {
          'x-page': ['1'],
          'x-total': ['2'],
          'x-total-pages': ['1'],
        },
      );

      final result = await repo.listIssues(IssuesRequest());

      final page = (result as Ok<PagingResponse<Issue>>).value;
      expect(page.data, hasLength(2));
      expect(page.total, 2);
      expect(page.page, 1);
    });
  });

  group('failure', () {
    // The point of the phase. These used to be thrown DioExceptions that flew
    // out of the repository and were caught by convention in HttpController.
    test('a 401 becomes a Failure carrying the status code', () async {
      final repo = repositoryThat((_) => (status: 401, body: {}));

      final result = await repo.getUser();

      expect(result, isA<Failure<User>>());
      final error = (result as Failure<User>).error;
      expect(error.statusCode, 401);
      expect(error.isUnauthorized, isTrue);
    });

    test('a 403 is distinguishable from a 404', () async {
      final forbidden = await repositoryThat((_) => (status: 403, body: {}))
          .getUser();
      final missing = await repositoryThat((_) => (status: 404, body: {}))
          .getUser();

      expect((forbidden as Failure<User>).error.isForbidden, isTrue);
      expect((missing as Failure<User>).error.isNotFound, isTrue);
      expect(forbidden.error.isNotFound, isFalse);
    });

    // Previously indistinguishable: a timeout and a 404 both arrived as the
    // same `null`.
    test('a transport failure has no status code', () async {
      final dio = Dio()
        ..httpClientAdapter = ThrowingHttpAdapter(
          DioExceptionType.connectionTimeout,
        );
      final repo =
          ApiRepository(apiProvider: ApiProvider(storage: storage, dio: dio));

      final result = await repo.getUser();

      final error = (result as Failure<User>).error;
      expect(error.statusCode, isNull);
      expect(error.isNetworkFailure, isTrue);
    });

    test('a malformed body is a Failure rather than a crash', () async {
      final repo = repositoryThat((_) => (status: 200, body: 'not an object'));

      final result = await repo.getUser();

      expect(result, isA<Failure<User>>());
    });
  });

  group('ApiResult helpers', () {
    test('valueOr returns the value on Ok and the fallback on Failure', () {
      expect(const Ok<int>(3).valueOr(9), 3);
      expect(const Failure<int>(ApiError(statusCode: 500)).valueOr(9), 9);
    });

    test('unwrap returns the value on Ok', () {
      expect(const Ok<int>(3).unwrap(), 3);
    });

    test('unwrap throws ApiException carrying the error on Failure', () {
      expect(
        () => const Failure<int>(ApiError(statusCode: 403)).unwrap(),
        throwsA(isA<ApiException>()
            .having((e) => e.error.statusCode, 'statusCode', 403)),
      );
    });
  });
}

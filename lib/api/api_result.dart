import 'package:dio/dio.dart';

/// The outcome of one call to [ApiRepository].
///
/// Every method used to return `T?`, with `null` standing in for every way a
/// request could go wrong — and callers wrote `?? PagingResponse<T>()`, so a
/// server error and an empty result were indistinguishable. Twenty-six other
/// methods returned a bare `bool`.
///
/// Both are replaced by this. Failures are now values with a status code
/// attached, and the compiler makes you look at them.
sealed class ApiResult<T> {
  const ApiResult();

  /// The value, or throw [ApiException].
  ///
  /// This is the bridge to `HttpController.runWithErrorHandling`, which drives
  /// the loading/error state machine and the 401 refresh from a `catch`.
  /// Controllers can be migrated to exhaustive `switch` one at a time.
  T unwrap() => switch (this) {
        Ok<T>(:final value) => value,
        Failure<T>(:final error) => throw ApiException(error),
      };
}

final class Ok<T> extends ApiResult<T> {
  const Ok(this.value);

  final T value;
}

final class Failure<T> extends ApiResult<T> {
  const Failure(this.error);

  final ApiError error;
}

/// Why a request failed.
///
/// [statusCode] is null when the request never got a response at all —
/// timeout, DNS, connection refused. That distinction was completely lost
/// before: it arrived as the same `null` as a 404.
class ApiError {
  const ApiError({
    this.statusCode,
    this.message,
    this.cause,
  });

  factory ApiError.fromDio(DioException e) => ApiError(
        statusCode: e.response?.statusCode,
        message: e.message,
        cause: e,
      );

  final int? statusCode;
  final String? message;
  final Object? cause;

  /// The token is expired or invalid; the refresh path handles this.
  bool get isUnauthorized => statusCode == 401;

  bool get isForbidden => statusCode == 403;

  bool get isNotFound => statusCode == 404;

  @override
  String toString() =>
      'ApiError(statusCode: $statusCode, message: $message)';
}

/// Thrown by [ApiResult.unwrap] so failures can travel through the existing
/// `try`/`catch` based controller helpers.
class ApiException implements Exception {
  const ApiException(this.error);

  final ApiError error;

  @override
  String toString() => 'ApiException($error)';
}

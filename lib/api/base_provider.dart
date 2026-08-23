import 'package:dio/dio.dart';
import 'package:labplus_for_gitlab/api/api_observer.dart';
import 'package:labplus_for_gitlab/shared/data/secure_storage.dart';

class BaseProvider {
  /// [storage] used to be fetched with `Get.find<SecureStorage>()` inside this
  /// constructor, which tied the transport layer to a live GetX container.
  /// Injecting it — along with [dio] — is what lets these providers be built
  /// against a fake adapter in a plain `test()`.
  BaseProvider({
    required SecureStorage storage,
    ApiObserver? observer,
    Dio? dio,
  })  : _storage = storage,
        _observer = observer,
        dio = dio ?? Dio() {
    const timeout = Duration(milliseconds: 8000);

    this.dio.options = BaseOptions(
          connectTimeout: timeout,
          sendTimeout: timeout,
          receiveTimeout: timeout,
        );

    this.dio.interceptors.add(InterceptorsWrapper(
          onRequest: (req, handler) {
            _observer?.onRequestStarted();
            final token = _storage.getToken();
            if (token.isNotEmpty) {
              req.headers['Authorization'] = 'Bearer $token';
            }
            req.baseUrl = _storage.getBaseurl();
            return handler.next(req);
          },
          // The old onResponse also toasted "An error occured" for any status
          // outside [200, 201, 202, 204]. That branch could never fire for a
          // real error: Dio's default validateStatus already routes every
          // non-2xx response to onError, so onResponse only ever saw 2xx. It
          // is gone rather than preserved — reporting errors is the caller's
          // job, and doing it here meant every call site got a toast it could
          // not suppress.
          onResponse: (res, handler) {
            _observer?.onRequestSettled();
            return handler.next(res);
          },
          onError: (e, handler) {
            _observer?.onRequestSettled();
            return handler.next(e);
          },
        ));
  }

  final SecureStorage _storage;
  final ApiObserver? _observer;
  final Dio dio;
}

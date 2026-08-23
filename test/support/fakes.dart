import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:labplus_for_gitlab/api/api.dart';
import 'package:labplus_for_gitlab/models/models.dart';
import 'package:labplus_for_gitlab/shared/shared.dart';

/// A [SecureStorage] that never touches the platform keychain.
///
/// The real one only reaches for `FlutterSecureStorage` inside `init()` and
/// `_save()`, so overriding the accessors is enough to keep it out of a plain
/// `test()`.
class FakeSecureStorage extends SecureStorage {
  FakeSecureStorage({this.token = '', this.baseUrl = 'https://gitlab.example'});

  String token;
  String baseUrl;

  /// Accounts handed back by [getDefaultAccount], and recorded writes.
  AppAccount? defaultAccount;
  final saved = <AppAccount>[];

  @override
  String getToken() => token;

  @override
  void setToken(String value) => token = value;

  @override
  String getBaseurl() => baseUrl;

  @override
  AppAccount? getDefaultAccount() => defaultAccount;

  @override
  Future<void> addUpdateAccount(AppAccount value) async {
    saved.add(value);
  }
}

/// Records that the transport layer signalled a settled request.
class RecordingApiObserver implements ApiObserver {
  int settled = 0;

  @override
  void onRequestSettled() => settled++;
}

/// Serves canned responses to Dio without opening a socket.
///
/// Each entry in [handlers] is matched against the request path. The captured
/// [requests] let a test assert on what the interceptors actually sent.
class FakeHttpAdapter implements HttpClientAdapter {
  FakeHttpAdapter(this.respond);

  /// Given the outgoing request, produce the status code and JSON body.
  final ({int status, Object? body}) Function(RequestOptions options) respond;

  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final result = respond(options);
    return ResponseBody.fromString(
      jsonEncode(result.body),
      result.status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

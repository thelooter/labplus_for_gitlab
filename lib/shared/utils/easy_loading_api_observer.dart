import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:labplus_for_gitlab/api/api_observer.dart';

/// Production [ApiObserver]: dismisses the global spinner once the last
/// in-flight request settles.
///
/// This is the only place the HTTP tier is allowed to touch the UI, and it is
/// injected rather than reached for.
///
/// The count matters. The old Dio interceptor called `EasyLoading.dismiss()`
/// on every settled response, so with three requests in flight the first one
/// back tore the spinner down while the other two were still running. Screens
/// that fan out several calls -- project details, the issue screen -- flickered
/// for exactly that reason.
class EasyLoadingApiObserver implements ApiObserver {
  EasyLoadingApiObserver();

  int _inFlight = 0;

  @override
  void onRequestStarted() => _inFlight++;

  @override
  void onRequestSettled() {
    if (_inFlight > 0) _inFlight--;
    if (_inFlight == 0) EasyLoading.dismiss();
  }
}

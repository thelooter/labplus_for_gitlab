import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:labplus_for_gitlab/api/api_observer.dart';

/// Production [ApiObserver]: dismisses the global spinner once a request
/// settles.
///
/// This is the only place the HTTP tier is allowed to touch the UI, and it is
/// injected rather than reached for. Controllers still call
/// `EasyLoading.show()`/`dismiss()` around their own long operations; this is
/// the belt-and-braces dismissal that used to live in the Dio interceptor.
class EasyLoadingApiObserver implements ApiObserver {
  const EasyLoadingApiObserver();

  @override
  void onRequestSettled() => EasyLoading.dismiss();
}

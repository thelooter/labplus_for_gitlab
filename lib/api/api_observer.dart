/// Side effects the transport layer has to trigger but must not own.
///
/// [BaseProvider] used to call `EasyLoading.dismiss()` straight from its Dio
/// interceptors. That single line was what made the whole HTTP tier
/// untestable: constructing a provider pulled in a Flutter binding, so nothing
/// below the controllers could be exercised without a widget test.
///
/// The production implementation is `EasyLoadingApiObserver` in
/// `lib/shared/utils/`, wired up in `AppBinding`. Tests pass their own, or
/// pass nothing at all.
abstract interface class ApiObserver {
  /// Called once a request has settled, whether it succeeded or failed.
  void onRequestSettled();
}

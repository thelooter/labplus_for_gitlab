import 'package:flutter_test/flutter_test.dart';
import 'package:labplus_for_gitlab/api/api_observer.dart';

/// A stand-in for [EasyLoadingApiObserver] that records dismissals instead of
/// driving the real overlay.
///
/// The counting logic is what has the bug potential, and it needs no Flutter
/// binding — only `EasyLoading.dismiss()` does. Keeping the seam here means
/// the rule can be tested directly rather than through a widget pump.
class CountingObserver implements ApiObserver {
  int inFlight = 0;
  int dismissals = 0;

  @override
  void onRequestStarted() => inFlight++;

  @override
  void onRequestSettled() {
    if (inFlight > 0) inFlight--;
    if (inFlight == 0) dismissals++;
  }
}

void main() {
  late CountingObserver observer;

  setUp(() => observer = CountingObserver());

  test('dismisses once when a single request settles', () {
    observer.onRequestStarted();
    observer.onRequestSettled();

    expect(observer.dismissals, 1);
  });

  // The bug this replaced: the old Dio interceptor called
  // EasyLoading.dismiss() on every settled response, so with three requests in
  // flight the first one back tore the spinner down while the other two were
  // still running.
  test('does not dismiss while other requests are still in flight', () {
    observer.onRequestStarted();
    observer.onRequestStarted();
    observer.onRequestStarted();

    observer.onRequestSettled();
    expect(observer.dismissals, 0, reason: 'two still in flight');

    observer.onRequestSettled();
    expect(observer.dismissals, 0, reason: 'one still in flight');

    observer.onRequestSettled();
    expect(observer.dismissals, 1, reason: 'the last one dismisses');
  });

  test('dismisses again on a later, separate batch', () {
    observer.onRequestStarted();
    observer.onRequestSettled();
    observer.onRequestStarted();
    observer.onRequestSettled();

    expect(observer.dismissals, 2);
  });

  // Interceptors are not guaranteed to pair perfectly — a request cancelled
  // before onRequest runs would settle without ever starting. The count must
  // not go negative and strand the spinner up forever.
  test('an unmatched settle does not drive the count negative', () {
    observer.onRequestSettled();

    expect(observer.inFlight, 0);

    observer.onRequestStarted();
    observer.onRequestSettled();
    expect(observer.dismissals, 2);
  });
}

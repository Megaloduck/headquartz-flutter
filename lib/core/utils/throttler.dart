import 'dart:async';

/// Throttles calls. Used to rate-limit broadcast messages.
class Throttler {
  Throttler({required this.duration});

  final Duration duration;
  DateTime? _last;
  Timer? _trailingTimer;
  void Function()? _trailingAction;

  void call(void Function() action) {
    final now = DateTime.now();
    if (_last == null || now.difference(_last!) >= duration) {
      _last = now;
      action();
      _trailingAction = null;
    } else {
      _trailingAction = action;
      _trailingTimer ??= Timer(duration - now.difference(_last!), () {
        _trailingTimer = null;
        if (_trailingAction != null) {
          _last = DateTime.now();
          _trailingAction!();
          _trailingAction = null;
        }
      });
    }
  }

  void cancel() {
    _trailingTimer?.cancel();
    _trailingTimer = null;
    _trailingAction = null;
  }
}

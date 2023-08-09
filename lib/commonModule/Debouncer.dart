import 'dart:async';

class Debouncer {
  final int delay;
  Timer? _timer;

  Debouncer({this.delay = 500});

  void call(Function() action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: delay), action);
  }
}
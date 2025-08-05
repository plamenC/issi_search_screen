import 'dart:async';
import 'package:flutter/foundation.dart';

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 300)});

  void call(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

class AsyncDebouncer {
  final Duration delay;
  Timer? _timer;
  Completer<void>? _completer;

  AsyncDebouncer({this.delay = const Duration(milliseconds: 300)});

  Future<void> call(Future<void> Function() action) async {
    _timer?.cancel();
    _completer?.complete();

    _completer = Completer<void>();
    _timer = Timer(delay, () async {
      try {
        await action();
        _completer?.complete();
      } catch (e) {
        _completer?.completeError(e);
      }
    });

    return _completer!.future;
  }

  void dispose() {
    _timer?.cancel();
    _completer?.complete();
  }
}

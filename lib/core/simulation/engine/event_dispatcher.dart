import 'dart:async';

/// Lightweight event bus for cross-cutting concerns (toasts, etc.).
class EventDispatcher<T> {
  final _ctrl = StreamController<T>.broadcast();
  Stream<T> get stream => _ctrl.stream;

  void emit(T event) => _ctrl.add(event);
  Future<void> dispose() => _ctrl.close();
}

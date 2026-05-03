import 'package:flutter/widgets.dart';

extension DoubleClampX on double {
  double clamp01() => clamp(0.0, 1.0).toDouble();
}

extension BuildContextX on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);
  bool get isCompactWidth => screenSize.width < 1280;
}

extension IterableX<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;

  Iterable<T> mapIndexed<T>(T Function(int i, E e) toElement) sync* {
    var i = 0;
    for (final e in this) {
      yield toElement(i++, e);
    }
  }
}

extension ListX<E> on List<E> {
  List<E> replaceWhere(bool Function(E) test, E Function(E) update) {
    return [
      for (final e in this)
        if (test(e)) update(e) else e,
    ];
  }
}

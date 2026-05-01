// lib/core/theme/theme_controller.dart
//
// Singleton ChangeNotifier that holds the active ThemeMode.
// MaterialApp listens to this via ListenableBuilder so the whole
// app rebuilds when the user toggles the theme.

import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  ThemeController._internal();
  static final ThemeController instance = ThemeController._internal();

  ThemeMode _mode = ThemeMode.light;
  ThemeMode get mode => _mode;

  bool get isDark => _mode == ThemeMode.dark;
  bool get isLight => _mode == ThemeMode.light;
  bool get isSystem => _mode == ThemeMode.system;

  /// Flip between light ↔ dark. Used by the AppBar toggle button.
  /// If currently following the system, this picks the opposite of
  /// whatever the system is showing.
  void toggle(BuildContext context) {
    if (_mode == ThemeMode.system) {
      final brightness = MediaQuery.platformBrightnessOf(context);
      _mode = brightness == Brightness.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    } else {
      _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    }
    notifyListeners();
  }

  void setMode(ThemeMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
  }
}
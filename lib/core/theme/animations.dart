import 'package:flutter/animation.dart';

/// Centralized animation timing and curves.
class AppAnimations {
  AppAnimations._();

  // Durations
  static const Duration instant = Duration(milliseconds: 80);
  static const Duration quick = Duration(milliseconds: 160);
  static const Duration normal = Duration(milliseconds: 240);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration extraSlow = Duration(milliseconds: 600);

  // Curves
  static const Curve standard = Curves.easeOutCubic;
  static const Curve emphasized = Curves.easeOutQuart;
  static const Curve decelerate = Curves.decelerate;
  static const Curve sharp = Curves.easeInOutQuart;
  static const Curve glow = Curves.easeInOutSine;

  // KPI value count-up
  static const Duration kpiTween = Duration(milliseconds: 600);
}

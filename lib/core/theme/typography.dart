import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized typography scale.
///
/// We use system fonts for desktop fidelity. Sizes follow an 11-step scale
/// optimised for high information density (Bloomberg / ERP terminal feel).
class AppTypography {
  AppTypography._();

  // Pinpoint families
  static const String _ui = 'Inter';
  static const String _mono = 'JetBrainsMono';

  /// Falls back to system if family file is not bundled.
  static const TextStyle _base = TextStyle(
    fontFamily: _ui,
    color: AppColors.textPrimary,
    height: 1.25,
    leadingDistribution: TextLeadingDistribution.even,
  );

  // Display
  static final TextStyle display = _base.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static final TextStyle h1 = _base.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  static final TextStyle h2 = _base.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
  );

  static final TextStyle h3 = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle h4 = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  // Body
  static final TextStyle body = _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static final TextStyle bodySmall = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static final TextStyle caption = _base.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    letterSpacing: 0.2,
  );

  static final TextStyle label = _base.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.8,
  );

  static final TextStyle button = _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  // KPI / data display
  static final TextStyle kpiHero = _base.copyWith(
    fontFamily: _mono,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static final TextStyle kpiValue = _base.copyWith(
    fontFamily: _mono,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle kpiLabel = label.copyWith(
    fontSize: 10,
    color: AppColors.textTertiary,
  );

  // Tables
  static final TextStyle tableHeader = _base.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.textSecondary,
  );

  static final TextStyle tableCell = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle tableCellMono = _base.copyWith(
    fontFamily: _mono,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  // Ticker / log
  static final TextStyle ticker = _base.copyWith(
    fontFamily: _mono,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.tickerGlow,
    letterSpacing: 0.3,
  );

  static final TextStyle clock = _base.copyWith(
    fontFamily: _mono,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    color: AppColors.accentBright,
  );
}

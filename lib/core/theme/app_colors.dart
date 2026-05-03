import 'package:flutter/material.dart';

/// Centralized color palette.
///
/// Headquartz uses a dark, terminal-inspired enterprise palette with
/// per-department accent neon hues. Colors are referenced through the
/// theme extension [HQColors] in widgets to support theme switching.
class AppColors {
  AppColors._();

  // ── Base surfaces ───────────────────────────────────────────────
  static const Color backgroundDeep = Color(0xFF05070A);
  static const Color background = Color(0xFF0A0E14);
  static const Color surface = Color(0xFF111720);
  static const Color surfaceElevated = Color(0xFF161D28);
  static const Color surfaceHover = Color(0xFF1B2330);
  static const Color border = Color(0xFF222B3A);
  static const Color borderFocus = Color(0xFF2F3D52);
  static const Color divider = Color(0xFF1A222E);

  // ── Glass overlays ───────────────────────────────────────────────
  static const Color glassFill = Color(0x1AFFFFFF); // 10% white
  static const Color glassBorder = Color(0x33FFFFFF); // 20% white

  // ── Text hierarchy ───────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFE6ECF3);
  static const Color textSecondary = Color(0xFF9FAFC2);
  static const Color textTertiary = Color(0xFF6B7B8E);
  static const Color textDisabled = Color(0xFF4A5566);

  // ── Semantic states ──────────────────────────────────────────────
  static const Color success = Color(0xFF00D68F);
  static const Color warning = Color(0xFFFFB020);
  static const Color danger = Color(0xFFFF4D6A);
  static const Color info = Color(0xFF3DA9FC);
  static const Color neutral = Color(0xFF6B7B8E);

  // ── Department neon accents ──────────────────────────────────────
  static const Color hr = Color(0xFF22D3EE); // Cyan
  static const Color finance = Color(0xFF22C55E); // Green
  static const Color sales = Color(0xFFA855F7); // Purple
  static const Color marketing = Color(0xFFA3E635); // Lime
  static const Color production = Color(0xFFFB923C); // Orange
  static const Color warehouse = Color(0xFF6366F1); // Indigo
  static const Color logistics = Color(0xFFFB7185); // Salmon
  static const Color chairman = Color(0xFFF5C518); // Gold

  // ── Chart palette (data viz) ─────────────────────────────────────
  static const List<Color> chartPalette = [
    Color(0xFF22D3EE),
    Color(0xFFA855F7),
    Color(0xFFFB923C),
    Color(0xFF22C55E),
    Color(0xFFA3E635),
    Color(0xFF6366F1),
    Color(0xFFFB7185),
    Color(0xFFF5C518),
  ];

  // ── Special accents ──────────────────────────────────────────────
  static const Color accent = Color(0xFF3DA9FC);
  static const Color accentBright = Color(0xFF60C2FF);
  static const Color tickerGlow = Color(0xFF00FFC2);

  /// Returns the accent color for a department key (e.g. "hr", "finance").
  static Color forDepartment(String? key) {
    switch (key?.toLowerCase()) {
      case 'hr':
        return hr;
      case 'finance':
        return finance;
      case 'sales':
        return sales;
      case 'marketing':
        return marketing;
      case 'production':
        return production;
      case 'warehouse':
        return warehouse;
      case 'logistics':
        return logistics;
      case 'chairman':
      case 'observer':
        return chairman;
    }
    return accent;
  }
}

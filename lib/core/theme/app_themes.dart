// lib/core/theme/app_themes.dart
//
// Light and dark themes, ported from the MAUI LightTheme.xaml and
// DarkTheme.xaml palettes:
//
//   Light                                Dark
//   ────────────────────────────         ────────────────────────────
//   PageBackground   #FAFAFB             PageBackground   #121212
//   CardBackground   #FFFFFF             CardBackground   #1E1E1E
//   PrimaryText      #1C1C1E             PrimaryText      #FFFFFF
//   SecondaryText    #5F6368             SecondaryText    #B0B0B0
//   TertiaryText     #9CA3AF             TertiaryText     #808080
//   Border           #D2D3DB             Border           #2C2C2C
//   Divider          #F1F3F5             Divider          #2C2C2C
//
// The brand seed (Headquartz amber #FFC107) is preserved across both
// themes, so AppBars and the login button stay on-brand.

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// Brand seed
// ─────────────────────────────────────────────
const Color kBrandAmber = Color(0xFFFFC107);

// ─────────────────────────────────────────────
// Palette tokens — exposed via a ThemeExtension
// so widgets can read them off `Theme.of(context)`.
// ─────────────────────────────────────────────
class HeadquartzColors extends ThemeExtension<HeadquartzColors> {
  final Color page;        // overall scaffold background
  final Color card;        // cards, tiles, search fields
  final Color primaryText;
  final Color secondaryText;
  final Color tertiaryText;
  final Color border;
  final Color divider;
  final Color shadow;

  const HeadquartzColors({
    required this.page,
    required this.card,
    required this.primaryText,
    required this.secondaryText,
    required this.tertiaryText,
    required this.border,
    required this.divider,
    required this.shadow,
  });

  static const light = HeadquartzColors(
    page: Color(0xFFFAFAFB),
    card: Color(0xFFFFFFFF),
    primaryText: Color(0xFF1C1C1E),
    secondaryText: Color(0xFF5F6368),
    tertiaryText: Color(0xFF9CA3AF),
    border: Color(0xFFD2D3DB),
    divider: Color(0xFFF1F3F5),
    shadow: Color(0x14000000), // ~8% black
  );

  static const dark = HeadquartzColors(
    page: Color(0xFF121212),
    card: Color(0xFF1E1E1E),
    primaryText: Color(0xFFFFFFFF),
    secondaryText: Color(0xFFB0B0B0),
    tertiaryText: Color(0xFF808080),
    border: Color(0xFF2C2C2C),
    divider: Color(0xFF2C2C2C),
    shadow: Color(0x66000000),
  );

  @override
  HeadquartzColors copyWith({
    Color? page,
    Color? card,
    Color? primaryText,
    Color? secondaryText,
    Color? tertiaryText,
    Color? border,
    Color? divider,
    Color? shadow,
  }) {
    return HeadquartzColors(
      page: page ?? this.page,
      card: card ?? this.card,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      tertiaryText: tertiaryText ?? this.tertiaryText,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  HeadquartzColors lerp(ThemeExtension<HeadquartzColors>? other, double t) {
    if (other is! HeadquartzColors) return this;
    return HeadquartzColors(
      page: Color.lerp(page, other.page, t)!,
      card: Color.lerp(card, other.card, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      tertiaryText: Color.lerp(tertiaryText, other.tertiaryText, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

// Convenience: `context.hq` to grab the palette tokens.
extension HeadquartzThemeX on BuildContext {
  HeadquartzColors get hq => Theme.of(this).extension<HeadquartzColors>()!;
}

// ─────────────────────────────────────────────
// LIGHT THEME
// ─────────────────────────────────────────────
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  fontFamily: 'Roboto',
  scaffoldBackgroundColor: HeadquartzColors.light.page,
  colorScheme: ColorScheme.fromSeed(
    seedColor: kBrandAmber,
    brightness: Brightness.light,
  ).copyWith(
    surface: HeadquartzColors.light.card,
  ),
  cardTheme: CardThemeData(
    color: HeadquartzColors.light.card,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: kBrandAmber,
    foregroundColor: Colors.black87,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: TextStyle(
      color: Colors.black87,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: Color(0xFFF1F3F5),
    thickness: 1,
    space: 1,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: HeadquartzColors.light.card,
    hintStyle: TextStyle(color: HeadquartzColors.light.tertiaryText),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF1C1C1E)),
    bodyMedium: TextStyle(color: Color(0xFF1C1C1E)),
    bodySmall: TextStyle(color: Color(0xFF5F6368)),
    titleLarge: TextStyle(color: Color(0xFF1C1C1E), fontWeight: FontWeight.w700),
    titleMedium: TextStyle(color: Color(0xFF1C1C1E), fontWeight: FontWeight.w700),
  ),
  iconTheme: const IconThemeData(color: Color(0xFF1C1C1E)),
  extensions: const [HeadquartzColors.light],
);

// ─────────────────────────────────────────────
// DARK THEME
// ─────────────────────────────────────────────
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  fontFamily: 'Roboto',
  scaffoldBackgroundColor: HeadquartzColors.dark.page,
  colorScheme: ColorScheme.fromSeed(
    seedColor: kBrandAmber,
    brightness: Brightness.dark,
  ).copyWith(
    surface: HeadquartzColors.dark.card,
  ),
  cardTheme: CardThemeData(
    color: HeadquartzColors.dark.card,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
  ),
  appBarTheme: const AppBarTheme(
    // Amber stays on dark too — it's the brand. Black text reads fine on amber.
    backgroundColor: kBrandAmber,
    foregroundColor: Colors.black87,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: TextStyle(
      color: Colors.black87,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: Color(0xFF2C2C2C),
    thickness: 1,
    space: 1,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: HeadquartzColors.dark.card,
    hintStyle: TextStyle(color: HeadquartzColors.dark.tertiaryText),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Color(0xFFB0B0B0)),
    titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
    titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  extensions: const [HeadquartzColors.dark],
);
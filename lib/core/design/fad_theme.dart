import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'fad_colors.dart';
import 'fad_tokens.dart';

/// Builds the two FAD themes. Display = Space Grotesk (geometric, techy),
/// body = Inter (clean, highly legible on low-end screens).
class FadTheme {
  const FadTheme._();

  static ThemeData light() => _build(FadColors.light);
  static ThemeData dark() => _build(FadColors.dark);

  static ThemeData _build(FadColors c) {
    final base = c.isDark ? ThemeData.dark(useMaterial3: true) : ThemeData.light(useMaterial3: true);

    // Bundled variable fonts (no runtime network fetch — offline-first).
    // FontVariation drives the exact weight on the variable axis.
    TextStyle d(double size, FontWeight w, {double? h, double? ls, Color? col}) => TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: size,
          fontWeight: w,
          fontVariations: [FontVariation('wght', w.value.toDouble())],
          height: h,
          letterSpacing: ls,
          color: col ?? c.textHigh,
        );
    TextStyle b(double size, FontWeight w, {double? h, Color? col}) => TextStyle(
          fontFamily: 'Inter',
          fontSize: size,
          fontWeight: w,
          fontVariations: [FontVariation('wght', w.value.toDouble())],
          height: h,
          color: col ?? c.textHigh,
        );

    final textTheme = TextTheme(
      displaySmall: d(34, FontWeight.w700, h: 1.1, ls: -0.5),
      headlineLarge: d(28, FontWeight.w700, h: 1.15, ls: -0.4),
      headlineMedium: d(23, FontWeight.w700, h: 1.2, ls: -0.3),
      headlineSmall: d(19, FontWeight.w600, h: 1.25),
      titleLarge: d(17, FontWeight.w600, h: 1.3),
      titleMedium: b(15.5, FontWeight.w600, h: 1.35),
      titleSmall: b(13.5, FontWeight.w600, h: 1.35, col: c.textMid),
      bodyLarge: b(15.5, FontWeight.w400, h: 1.5),
      bodyMedium: b(14, FontWeight.w400, h: 1.5, col: c.textMid),
      bodySmall: b(12.5, FontWeight.w400, h: 1.45, col: c.textLow),
      labelLarge: b(14, FontWeight.w600, h: 1.2),
      labelMedium: b(12.5, FontWeight.w600, h: 1.2, col: c.textMid),
      labelSmall: b(11, FontWeight.w600, h: 1.2, col: c.textLow),
    );

    final scheme = ColorScheme(
      brightness: c.brightness,
      primary: c.primary,
      onPrimary: c.onPrimary,
      secondary: c.accent,
      onSecondary: c.onPrimary,
      error: c.danger,
      onError: Colors.white,
      surface: c.surface,
      onSurface: c.textHigh,
      surfaceContainerHighest: c.surfaceStrong,
      outline: c.surfaceBorder,
    );

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: c.bgBase,
      canvasColor: c.bgBase,
      textTheme: textTheme,
      primaryColor: c.primary,
      splashFactory: InkSparkle.splashFactory,
      extensions: [c],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(color: c.textHigh),
        systemOverlayStyle: c.isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      dividerTheme: DividerThemeData(color: c.surfaceBorder, thickness: 1, space: 1),
      iconTheme: IconThemeData(color: c.textMid, size: 22),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.surfaceStrong,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: c.textHigh),
        shape: const RoundedRectangleBorder(borderRadius: FadRadius.rMd),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.isDark ? c.bgGradientTop : c.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(FadRadius.xl)),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: c.textHigh,
        unselectedLabelColor: c.textLow,
        indicatorColor: c.accent,
        dividerColor: Colors.transparent,
        labelStyle: textTheme.titleSmall?.copyWith(color: c.textHigh),
      ),
    );
  }
}

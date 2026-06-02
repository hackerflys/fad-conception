import 'package:flutter/material.dart';

/// Brand palette tokens (raw values, from the validated visual identity).
class FadBrand {
  const FadBrand._();
  static const Color navy = Color(0xFF061427);
  static const Color deepBlue = Color(0xFF083A78);
  static const Color techBlue = Color(0xFF0D7CFF);
  static const Color cyan = Color(0xFF18D4FF);
  static const Color coldWhite = Color(0xFFF4FBFF);
  static const Color textGrey = Color(0xFF6B7A90);
  static const Color darkBg = Color(0xFF020711);

  // Functional accents derived to stay in the same family.
  static const Color success = Color(0xFF18D4A8);
  static const Color warning = Color(0xFFFFB23E);
  static const Color danger = Color(0xFFFF5A6A);
  static const Color violet = Color(0xFF7C6BFF);
}

/// Adaptive semantic colors exposed through the theme so every widget reads
/// the same tokens in light and dark — no hard-coded `Colors.x` in screens.
@immutable
class FadColors extends ThemeExtension<FadColors> {
  const FadColors({
    required this.brightness,
    required this.bgBase,
    required this.bgGradientTop,
    required this.bgGradientBottom,
    required this.surface,
    required this.surfaceStrong,
    required this.surfaceBorder,
    required this.primary,
    required this.accent,
    required this.onPrimary,
    required this.textHigh,
    required this.textMid,
    required this.textLow,
    required this.success,
    required this.warning,
    required this.danger,
    required this.violet,
    required this.glow,
  });

  final Brightness brightness;
  final Color bgBase;
  final Color bgGradientTop;
  final Color bgGradientBottom;
  final Color surface;
  final Color surfaceStrong;
  final Color surfaceBorder;
  final Color primary;
  final Color accent;
  final Color onPrimary;
  final Color textHigh;
  final Color textMid;
  final Color textLow;
  final Color success;
  final Color warning;
  final Color danger;
  final Color violet;
  final Color glow;

  bool get isDark => brightness == Brightness.dark;

  /// Signature brand gradient (tech blue -> cyan).
  LinearGradient get brandGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primary, accent],
      );

  static const FadColors dark = FadColors(
    brightness: Brightness.dark,
    bgBase: Color(0xFF020711),
    bgGradientTop: Color(0xFF071A33),
    bgGradientBottom: Color(0xFF020711),
    surface: Color(0x14FFFFFF),
    surfaceStrong: Color(0x1FFFFFFF),
    surfaceBorder: Color(0x1FB8D4FF),
    primary: FadBrand.techBlue,
    accent: FadBrand.cyan,
    onPrimary: Color(0xFF02101F),
    textHigh: Color(0xFFF4FBFF),
    textMid: Color(0xFF9DB2CE),
    textLow: Color(0xFF6B7A90),
    success: FadBrand.success,
    warning: FadBrand.warning,
    danger: FadBrand.danger,
    violet: FadBrand.violet,
    glow: Color(0x4D18D4FF),
  );

  static const FadColors light = FadColors(
    brightness: Brightness.light,
    bgBase: Color(0xFFEFF6FF),
    bgGradientTop: Color(0xFFFFFFFF),
    bgGradientBottom: Color(0xFFE3EEFB),
    surface: Color(0xFFFFFFFF),
    surfaceStrong: Color(0xFFFFFFFF),
    surfaceBorder: Color(0xFFD7E5F5),
    primary: FadBrand.techBlue,
    accent: Color(0xFF0AA6E0),
    onPrimary: Color(0xFFFFFFFF),
    textHigh: Color(0xFF061427),
    textMid: Color(0xFF44566E),
    textLow: Color(0xFF8195AD),
    success: Color(0xFF0FA98A),
    warning: Color(0xFFE08A00),
    danger: Color(0xFFE23B4C),
    violet: FadBrand.violet,
    glow: Color(0x330D7CFF),
  );

  @override
  FadColors copyWith({
    Brightness? brightness,
    Color? bgBase,
    Color? bgGradientTop,
    Color? bgGradientBottom,
    Color? surface,
    Color? surfaceStrong,
    Color? surfaceBorder,
    Color? primary,
    Color? accent,
    Color? onPrimary,
    Color? textHigh,
    Color? textMid,
    Color? textLow,
    Color? success,
    Color? warning,
    Color? danger,
    Color? violet,
    Color? glow,
  }) {
    return FadColors(
      brightness: brightness ?? this.brightness,
      bgBase: bgBase ?? this.bgBase,
      bgGradientTop: bgGradientTop ?? this.bgGradientTop,
      bgGradientBottom: bgGradientBottom ?? this.bgGradientBottom,
      surface: surface ?? this.surface,
      surfaceStrong: surfaceStrong ?? this.surfaceStrong,
      surfaceBorder: surfaceBorder ?? this.surfaceBorder,
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      onPrimary: onPrimary ?? this.onPrimary,
      textHigh: textHigh ?? this.textHigh,
      textMid: textMid ?? this.textMid,
      textLow: textLow ?? this.textLow,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      violet: violet ?? this.violet,
      glow: glow ?? this.glow,
    );
  }

  @override
  FadColors lerp(ThemeExtension<FadColors>? other, double t) {
    if (other is! FadColors) return this;
    return FadColors(
      brightness: t < 0.5 ? brightness : other.brightness,
      bgBase: Color.lerp(bgBase, other.bgBase, t)!,
      bgGradientTop: Color.lerp(bgGradientTop, other.bgGradientTop, t)!,
      bgGradientBottom: Color.lerp(bgGradientBottom, other.bgGradientBottom, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceStrong: Color.lerp(surfaceStrong, other.surfaceStrong, t)!,
      surfaceBorder: Color.lerp(surfaceBorder, other.surfaceBorder, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      textHigh: Color.lerp(textHigh, other.textHigh, t)!,
      textMid: Color.lerp(textMid, other.textMid, t)!,
      textLow: Color.lerp(textLow, other.textLow, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      violet: Color.lerp(violet, other.violet, t)!,
      glow: Color.lerp(glow, other.glow, t)!,
    );
  }
}

/// Sugar: `context.fad` to reach the palette, `context.fadText` for text theme.
extension FadColorsX on BuildContext {
  FadColors get fad => Theme.of(this).extension<FadColors>() ?? FadColors.dark;
}

import 'package:flutter/widgets.dart';

/// Spacing, radius and motion scale for FAD Conception.
/// One coherent grid — everything snaps to multiples of 4.
class FadGap {
  const FadGap._();
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

class FadRadius {
  const FadRadius._();
  static const double sm = 14;
  static const double md = 20;
  static const double lg = 26;
  static const double xl = 32;
  static const double pill = 999;

  static const BorderRadius rSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius rMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius rLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius rXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius rPill = BorderRadius.all(Radius.circular(pill));
}

class FadMotion {
  const FadMotion._();
  static const Duration fast = Duration(milliseconds: 180);
  static const Duration base = Duration(milliseconds: 280);
  static const Duration slow = Duration(milliseconds: 520);
  static const Curve curve = Curves.easeOutCubic;
}

/// Page-level horizontal padding used across the app.
const EdgeInsets kScreenPadding = EdgeInsets.symmetric(horizontal: FadGap.lg);

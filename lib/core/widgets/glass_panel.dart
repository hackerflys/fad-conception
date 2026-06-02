import 'package:flutter/material.dart';

import '../design/fad_colors.dart';
import '../design/fad_tokens.dart';

/// Layered translucent surface — the building block that replaces flat cards.
/// Hairline border + soft depth, optional brand glow. In dark mode it reads as
/// frosted glass; in light mode as a soft elevated sheet.
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(FadGap.md),
    this.radius = FadRadius.lg,
    this.onTap,
    this.glow = false,
    this.strong = false,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;
  final bool glow;
  final bool strong;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    final br = BorderRadius.circular(radius);
    final panel = AnimatedContainer(
      duration: FadMotion.fast,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: br,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: c.isDark
              ? [
                  Colors.white.withValues(alpha: strong ? 0.10 : 0.06),
                  Colors.white.withValues(alpha: strong ? 0.04 : 0.02),
                ]
              : [c.surface, c.surface],
        ),
        border: Border.all(color: borderColor ?? c.surfaceBorder, width: 1),
        boxShadow: [
          if (glow)
            BoxShadow(
              color: c.glow,
              blurRadius: 34,
              spreadRadius: -6,
              offset: const Offset(0, 10),
            )
          else if (!c.isDark)
            BoxShadow(
              color: const Color(0xFF0D2A55).withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return panel;
    return Material(
      color: Colors.transparent,
      borderRadius: br,
      child: InkWell(
        onTap: onTap,
        borderRadius: br,
        splashColor: c.accent.withValues(alpha: 0.08),
        highlightColor: c.accent.withValues(alpha: 0.04),
        child: panel,
      ),
    );
  }
}

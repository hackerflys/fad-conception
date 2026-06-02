import 'package:flutter/material.dart';

import '../design/fad_colors.dart';
import '../design/fad_tokens.dart';

enum FadButtonKind { primary, ghost, soft }

/// Primary action with the brand gradient and a soft glow, plus ghost/soft
/// variants. Pill-shaped, generous touch target.
class FadButton extends StatelessWidget {
  const FadButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.kind = FadButtonKind.primary,
    this.expand = true,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final FadButtonKind kind;
  final bool expand;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    final disabled = onPressed == null || loading;

    final content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation(
                kind == FadButtonKind.primary ? c.onPrimary : c.primary,
              ),
            ),
          )
        else ...[
          if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: FadGap.xs)],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: kind == FadButtonKind.primary ? c.onPrimary : c.textHigh,
                  ),
            ),
          ),
        ],
      ],
    );

    final BoxDecoration deco;
    switch (kind) {
      case FadButtonKind.primary:
        deco = BoxDecoration(
          borderRadius: FadRadius.rPill,
          gradient: c.brandGradient,
          boxShadow: disabled
              ? null
              : [BoxShadow(color: c.glow, blurRadius: 24, spreadRadius: -4, offset: const Offset(0, 8))],
        );
      case FadButtonKind.soft:
        deco = BoxDecoration(
          borderRadius: FadRadius.rPill,
          color: c.primary.withValues(alpha: c.isDark ? 0.16 : 0.10),
          border: Border.all(color: c.primary.withValues(alpha: 0.30)),
        );
      case FadButtonKind.ghost:
        deco = BoxDecoration(
          borderRadius: FadRadius.rPill,
          border: Border.all(color: c.surfaceBorder),
        );
    }

    return Opacity(
      opacity: disabled && !loading ? 0.5 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: disabled ? null : onPressed,
          borderRadius: FadRadius.rPill,
          child: Ink(
            decoration: deco,
            child: IconTheme(
              data: IconThemeData(
                color: kind == FadButtonKind.primary ? c.onPrimary : c.primary,
              ),
              child: Container(
                constraints: const BoxConstraints(minHeight: 54),
                padding: const EdgeInsets.symmetric(horizontal: FadGap.xl),
                alignment: Alignment.center,
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

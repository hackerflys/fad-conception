import 'package:flutter/material.dart';

import '../design/fad_colors.dart';
import '../design/fad_icons.dart';
import '../design/fad_tokens.dart';
import 'atom_background.dart';
import 'duo_icon.dart';

/// Immersive scaffold: atom backdrop behind a transparent Scaffold.
class FadScaffold extends StatelessWidget {
  const FadScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.intensity = 1,
    this.bottomInsetForNav = false,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final double intensity;
  final bool bottomInsetForNav;

  @override
  Widget build(BuildContext context) {
    return AtomBackground(
      intensity: intensity,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: appBar,
        floatingActionButton: floatingActionButton,
        body: body,
      ),
    );
  }
}

/// Round, glassy icon button used in app bars.
class FadIconButton extends StatelessWidget {
  const FadIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.badge = 0,
    this.tooltip,
  });

  final String icon;
  final VoidCallback? onTap;
  final int badge;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    final btn = GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: c.surface,
          border: Border.all(color: c.surfaceBorder),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            DuoIcon(icon, size: 22),
            if (badge > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: c.danger, shape: BoxShape.circle),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    badge > 9 ? '9+' : '$badge',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    return tooltip == null ? btn : Tooltip(message: tooltip!, child: btn);
  }
}

/// Section header with a title and optional trailing action.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    return Padding(
      padding: const EdgeInsets.only(bottom: FadGap.sm, top: FadGap.lg),
      child: Row(
        children: [
          Container(width: 4, height: 18, decoration: BoxDecoration(gradient: c.brandGradient, borderRadius: FadRadius.rPill)),
          const SizedBox(width: FadGap.sm),
          Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(action!, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: c.accent)),
            ),
        ],
      ),
    );
  }
}

/// Pill chip. Selectable variant uses the brand gradient when active.
class FadChip extends StatelessWidget {
  const FadChip({
    super.key,
    required this.label,
    this.icon,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final String? icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: FadMotion.fast,
        padding: const EdgeInsets.symmetric(horizontal: FadGap.md, vertical: FadGap.xs + 2),
        decoration: BoxDecoration(
          borderRadius: FadRadius.rPill,
          gradient: selected ? c.brandGradient : null,
          color: selected ? null : c.surface,
          border: Border.all(color: selected ? Colors.transparent : c.surfaceBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              DuoIcon(icon!, size: 16, color: selected ? c.onPrimary : null),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: selected ? c.onPrimary : c.textMid,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small status badge, e.g. "Vérifié".
class FadBadge extends StatelessWidget {
  const FadBadge({super.key, required this.label, this.icon = FadIcons.checkCircle, this.color});

  final String label;
  final String icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    final col = color ?? c.success;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: FadRadius.rPill,
        color: col.withValues(alpha: 0.14),
        border: Border.all(color: col.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DuoIcon(icon, size: 13, color: col),
          const SizedBox(width: 5),
          Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: col, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

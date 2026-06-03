import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design/fad_colors.dart';
import '../design/fad_icons.dart';
import '../design/fad_tokens.dart';
import 'atom_background.dart';
import 'duo_icon.dart';

VoidCallback? _haptic(VoidCallback? cb) =>
    cb == null ? null : () { HapticFeedback.selectionClick(); cb(); };

/// Immersive scaffold: atom backdrop behind a transparent Scaffold.
class FadScaffold extends StatelessWidget {
  const FadScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.intensity = 1,
    this.bottomInsetForNav = false,
    this.topSmoke = true,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final double intensity;
  final bool bottomInsetForNav;

  /// Soft "smoke" fade at the very top so content dissolves under the status
  /// bar. Disable on screens that draw their own header smoke (e.g. Radar).
  final bool topSmoke;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    final topInset = MediaQuery.paddingOf(context).top;
    return AtomBackground(
      intensity: intensity,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: appBar,
        floatingActionButton: floatingActionButton,
        body: Stack(
          children: [
            body,
            if (topSmoke && appBar == null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: topInset + 64,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [c.bgBase, c.bgBase.withValues(alpha: 0)],
                        stops: const [0.4, 1],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
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
      onTap: _haptic(onTap),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: c.isDark ? Colors.white.withValues(alpha: 0.10) : c.surface,
          border: Border.all(color: c.isDark ? Colors.white.withValues(alpha: 0.18) : c.surfaceBorder),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            DuoIcon(icon, size: 22, color: c.textHigh),
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
      onTap: _haptic(onTap),
      child: AnimatedContainer(
        duration: FadMotion.fast,
        padding: const EdgeInsets.symmetric(horizontal: FadGap.md, vertical: FadGap.xs + 2),
        decoration: BoxDecoration(
          borderRadius: FadRadius.rPill,
          gradient: selected ? c.brandGradient : null,
          color: selected ? null : (c.isDark ? Colors.white.withValues(alpha: 0.08) : c.surface),
          border: Border.all(color: selected ? Colors.transparent : c.surfaceBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              DuoIcon(icon!, size: 16, color: selected ? c.onPrimary : c.textHigh),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: selected ? c.onPrimary : c.textHigh,
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

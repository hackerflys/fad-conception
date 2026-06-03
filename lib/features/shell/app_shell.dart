import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/design/fad_colors.dart';
import '../../core/design/fad_icons.dart';
import '../../core/design/fad_tokens.dart';
import '../../core/widgets/duo_icon.dart';
import '../../l10n/l10n_ext.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          shell,
          // "Smoke": content fades into the background at the bottom, behind
          // the floating nav, so deep scrolls dissolve softly.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 150,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      c.bgBase.withValues(alpha: 0),
                      c.bgBase.withValues(alpha: 0.6),
                      c.bgBase.withValues(alpha: 0.95),
                    ],
                    stops: const [0, 0.55, 1],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _FadBottomNav(
        index: shell.currentIndex,
        onTap: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
      ),
    );
  }
}

class _FadBottomNav extends StatelessWidget {
  const _FadBottomNav({required this.index, required this.onTap});

  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    final l = context.l10n;
    final items = [
      (FadIcons.radar, l.navRadar),
      (FadIcons.learn, l.navLearn),
      (FadIcons.projects, l.navProjects),
      (FadIcons.profile, l.navProfile),
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(FadGap.xl, 0, FadGap.xl, FadGap.xs),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: FadRadius.rPill,
            color: c.isDark ? const Color(0xFF0C1E38) : Colors.white,
            border: Border.all(color: c.surfaceBorder),
            boxShadow: [
              BoxShadow(
                color: c.isDark ? Colors.black.withValues(alpha: 0.5) : const Color(0xFF0D2A55).withValues(alpha: 0.14),
                blurRadius: 26,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _NavItem(
                    icon: items[i].$1,
                    label: items[i].$2,
                    selected: index == i,
                    onTap: () => onTap(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    // Solid, neutral colours read far better in a small nav bar than duotone.
    final iconColor = selected ? c.onPrimary : (c.isDark ? c.textMid : c.textLow);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: FadMotion.base,
        curve: FadMotion.curve,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: FadRadius.rPill,
          gradient: selected ? c.brandGradient : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DuoIcon(icon, size: 27, color: iconColor),
            if (selected) ...[
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: c.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

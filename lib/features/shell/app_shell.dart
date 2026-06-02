import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/design/fad_colors.dart';
import '../../core/design/fad_icons.dart';
import '../../core/design/fad_tokens.dart';
import '../../l10n/l10n_ext.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: shell,
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
      (FadIcons.radar, FadIcons.radarFill, l.navRadar),
      (FadIcons.learn, FadIcons.learnFill, l.navLearn),
      (FadIcons.projects, FadIcons.projectsFill, l.navProjects),
      (FadIcons.profile, FadIcons.profileFill, l.navProfile),
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(FadGap.lg, 0, FadGap.lg, FadGap.sm),
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            borderRadius: FadRadius.rPill,
            color: c.isDark ? const Color(0xFF0A1A30).withValues(alpha: 0.92) : Colors.white,
            border: Border.all(color: c.surfaceBorder),
            boxShadow: [
              BoxShadow(
                color: c.isDark ? Colors.black.withValues(alpha: 0.45) : const Color(0xFF0D2A55).withValues(alpha: 0.12),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _NavItem(
                    icon: items[i].$1,
                    activeIcon: items[i].$2,
                    label: items[i].$3,
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
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: FadMotion.base,
        curve: FadMotion.curve,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: FadRadius.rPill,
          gradient: selected ? c.brandGradient : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? activeIcon : icon,
              size: 24,
              color: selected ? c.onPrimary : c.textLow,
            ),
            if (selected) ...[
              const SizedBox(width: 8),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design/fad_colors.dart';
import '../../core/widgets/duo_icon.dart';
import '../../core/design/fad_icons.dart';
import '../../core/design/fad_tokens.dart';
import '../../core/widgets/fad_common.dart';
import '../../core/widgets/glass_panel.dart';
import '../../l10n/l10n_ext.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fad;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;

    Widget stat(String value, String label) => Expanded(
          child: Column(children: [
            Text(value, style: t.headlineMedium?.copyWith(color: c.accent)),
            Text(label, style: t.labelSmall),
          ]),
        );

    Widget tile(String icon, String label, {VoidCallback? onTap}) => GlassPanel(
          onTap: onTap ?? () {},
          padding: const EdgeInsets.symmetric(horizontal: FadGap.md, vertical: FadGap.sm),
          child: Row(children: [
            DuoIcon(icon, color: c.accent, size: 22),
            const SizedBox(width: FadGap.sm),
            Expanded(child: Text(label, style: t.titleMedium)),
            DuoIcon(FadIcons.forward, color: c.textLow, size: 18),
          ]),
        );

    return FadScaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(FadGap.lg, FadGap.sm, FadGap.lg, 120),
          children: [
            Row(children: [
              Expanded(child: Text(l.navProfile, style: t.headlineLarge)),
              FadIconButton(icon: FadIcons.gear, onTap: () => context.push('/settings')),
            ]),
            const SizedBox(height: FadGap.md),
            GlassPanel(
              strong: true,
              glow: true,
              child: Column(children: [
                Row(children: [
                  Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(shape: BoxShape.circle, gradient: c.brandGradient),
                    child: DuoIcon(FadIcons.profileFill, color: c.onPrimary, size: 34),
                  ),
                  const SizedBox(width: FadGap.md),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Alex builder', style: t.titleLarge),
                      const SizedBox(height: 4),
                      FadBadge(label: '${l.profileContributorLevel} 2', icon: FadIcons.trophy, color: c.warning),
                    ]),
                  ),
                ]),
                const SizedBox(height: FadGap.md),
                Row(children: [
                  stat('3', l.statProjects),
                  stat('12', l.statLessons),
                  stat('48', l.statShares),
                ]),
              ]),
            ),
            const SizedBox(height: FadGap.lg),
            tile(FadIcons.bookmark, l.profileSaved),
            const SizedBox(height: FadGap.xs),
            tile(FadIcons.projects, l.profileSubmitted),
            const SizedBox(height: FadGap.xs),
            tile(FadIcons.lesson, l.profileProgress),
            const SizedBox(height: FadGap.xs),
            tile(FadIcons.messages, l.navMessages, onTap: () => context.push('/messages')),
            const SizedBox(height: FadGap.xs),
            tile(FadIcons.invite, l.profileInvite),
            const SizedBox(height: FadGap.xs),
            tile(FadIcons.gear, l.settingsTitle, onTap: () => context.push('/settings')),
          ],
        ),
      ),
    );
  }
}

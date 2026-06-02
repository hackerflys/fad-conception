import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/demo_data.dart';
import '../../core/design/fad_colors.dart';
import '../../core/widgets/duo_icon.dart';
import '../../core/design/fad_icons.dart';
import '../../core/design/fad_tokens.dart';
import '../../core/widgets/fad_common.dart';
import '../../core/widgets/fad_logo.dart';
import '../../l10n/l10n_ext.dart';
import 'widgets/signal_card.dart';

class RadarScreen extends ConsumerStatefulWidget {
  const RadarScreen({super.key});

  @override
  ConsumerState<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends ConsumerState<RadarScreen> {
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    final l = context.l10n;
    final signals = ref.watch(signalsProvider);
    final ofDay = ref.watch(signalOfDayProvider);
    final filters = [l.radarFilterForYou, l.radarFilterRecent, l.radarFilterPopular, l.radarFilterCameroon];

    return FadScaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(FadGap.lg, FadGap.sm, FadGap.lg, 0),
                child: Row(
                  children: [
                    const Expanded(child: FadWordmark(compact: true)),
                    FadIconButton(icon: FadIcons.search, onTap: () => context.push('/search')),
                    const SizedBox(width: FadGap.xs),
                    FadIconButton(
                      icon: FadIcons.messages,
                      badge: 2,
                      onTap: () => context.push('/messages'),
                    ),
                    const SizedBox(width: FadGap.xs),
                    FadIconButton(icon: FadIcons.bell, onTap: () {}),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: kScreenPadding,
              sliver: SliverList.list(children: [
                Padding(
                  padding: const EdgeInsets.only(top: FadGap.lg, bottom: FadGap.sm),
                  child: Row(
                    children: [
                      DuoIcon(FadIcons.sparkle, size: 18, color: c.accent),
                      const SizedBox(width: 6),
                      Text(l.radarSignalOfDay, style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ),
                SignalCard(signal: ofDay, featured: true),
              ]),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: FadGap.lg, vertical: FadGap.xs),
                  itemCount: filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: FadGap.xs),
                  itemBuilder: (_, i) => FadChip(
                    label: filters[i],
                    selected: _filter == i,
                    onTap: () => setState(() => _filter = i),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(FadGap.lg, FadGap.xs, FadGap.lg, 120),
              sliver: SliverList.separated(
                itemCount: signals.length,
                separatorBuilder: (_, __) => const SizedBox(height: FadGap.sm),
                itemBuilder: (_, i) => SignalCard(signal: signals[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

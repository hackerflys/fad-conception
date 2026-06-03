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
      topSmoke: false,
      body: CustomScrollView(
        slivers: [
          // Collapsing header: hides when you scroll down, snaps back when you
          // scroll up for quick access to search / messages / notifications.
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: false,
            primary: true,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    c.bgBase,
                    c.bgBase.withValues(alpha: 0.92),
                    c.bgBase.withValues(alpha: 0),
                  ],
                  stops: const [0, 0.62, 1],
                ),
              ),
            ),
            toolbarHeight: 60,
            titleSpacing: FadGap.lg,
            title: const FadWordmark(compact: true),
            actions: [
              FadIconButton(icon: FadIcons.search, onTap: () => context.push('/search')),
              const SizedBox(width: FadGap.xs),
              FadIconButton(icon: FadIcons.messages, badge: 2, onTap: () => context.push('/messages')),
              const SizedBox(width: FadGap.xs),
              FadIconButton(icon: FadIcons.bell, onTap: () {}),
              const SizedBox(width: FadGap.lg),
            ],
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
              child: Padding(
                padding: const EdgeInsets.only(top: FadGap.md),
                child: SizedBox(
                  height: 50,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: FadGap.lg),
                    itemCount: filters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: FadGap.xs),
                    itemBuilder: (_, i) => Center(
                      child: FadChip(
                        label: filters[i],
                        selected: _filter == i,
                        onTap: () => setState(() => _filter = i),
                      ),
                    ),
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
    );
  }
}

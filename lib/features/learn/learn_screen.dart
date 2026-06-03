import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/demo_data.dart';
import '../../core/design/fad_colors.dart';
import '../../core/widgets/duo_icon.dart';
import '../../core/design/fad_icons.dart';
import '../../core/design/fad_tokens.dart';
import '../../core/widgets/fad_button.dart';
import '../../core/widgets/fad_common.dart';
import '../../core/widgets/glass_panel.dart';
import '../../l10n/l10n_ext.dart';

class LearnScreen extends ConsumerWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fad;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final lessons = ref.watch(lessonsProvider);
    final series = ref.watch(seriesProvider);

    return FadScaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(FadGap.lg, FadGap.sm, FadGap.lg, 120),
          children: [
            Text(l.learnTitle, style: t.headlineLarge),
            const SizedBox(height: FadGap.md),
            GlassPanel(
              glow: true,
              strong: true,
              child: Row(children: [
                DuoIcon(FadIcons.trophy, color: c.accent, size: 28),
                const SizedBox(width: FadGap.sm),
                Expanded(child: Text(l.learnFullPathsSoon, style: t.titleMedium)),
                FadButton(
                  label: l.learnNotifyMe,
                  kind: FadButtonKind.soft,
                  expand: false,
                  onPressed: () {},
                ),
              ]),
            ),
            SectionHeader(title: l.learnMiniLessons),
            for (final lesson in lessons)
              Padding(
                padding: const EdgeInsets.only(bottom: FadGap.sm),
                child: GlassPanel(
                  onTap: () => context.push('/lesson/${lesson.id}'),
                  child: Row(children: [
                    Container(
                      width: 46, height: 46,
                      decoration: BoxDecoration(borderRadius: FadRadius.rSm, color: c.primary.withValues(alpha: 0.14)),
                      child: DuoIcon(FadIcons.lesson, color: c.accent),
                    ),
                    const SizedBox(width: FadGap.sm),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(lesson.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: t.titleMedium),
                        Text('${lesson.durationLabel} · ${lesson.level}', style: t.bodySmall),
                      ]),
                    ),
                    DuoIcon(FadIcons.play, color: c.accent, size: 26),
                  ]),
                ),
              ),
            SectionHeader(title: l.learnSeries),
            SizedBox(
              height: 176,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: series.length,
                separatorBuilder: (_, __) => const SizedBox(width: FadGap.sm),
                itemBuilder: (_, i) {
                  final s = series[i];
                  return SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.74,
                    child: GlassPanel(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          DuoIcon(FadIcons.series, color: c.violet),
                          const Spacer(),
                          Text('${s.episodes} ép.', style: t.labelSmall),
                        ]),
                        const SizedBox(height: FadGap.xs),
                        Text(s.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: t.titleMedium),
                        const SizedBox(height: 2),
                        Expanded(
                          child: Text(s.description,
                              maxLines: 3, overflow: TextOverflow.ellipsis, style: t.bodySmall),
                        ),
                        ClipRRect(
                          borderRadius: FadRadius.rPill,
                          child: LinearProgressIndicator(
                            value: s.progress,
                            minHeight: 6,
                            backgroundColor: c.surfaceBorder,
                            valueColor: AlwaysStoppedAnimation(c.accent),
                          ),
                        ),
                      ]),
                    ),
                  );
                },
              ),
            ),
            SectionHeader(title: l.learnGlossary),
            GlassPanel(
              onTap: () {},
              child: Row(children: [
                DuoIcon(FadIcons.glossary, color: c.accent),
                const SizedBox(width: FadGap.sm),
                Expanded(child: Text('API · SDK · RLS · LLM · CI/CD …', style: t.bodyLarge)),
                DuoIcon(FadIcons.forward, color: c.textLow),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

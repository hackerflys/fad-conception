import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/demo_data.dart';
import '../../core/design/fad_colors.dart';
import '../../core/design/fad_icons.dart';
import '../../core/design/fad_tokens.dart';
import '../../core/widgets/fad_button.dart';
import '../../core/widgets/fad_common.dart';
import '../../core/widgets/glass_panel.dart';
import '../../l10n/l10n_ext.dart';

class LessonDetailScreen extends ConsumerWidget {
  const LessonDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fad;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final lesson = lessonById(ref, id);

    return FadScaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: FadGap.lg),
          child: FadIconButton(icon: FadIcons.back, onTap: () => context.pop()),
        ),
      ),
      body: lesson == null
          ? Center(child: Text(l.stateEmpty, style: t.bodyMedium))
          : SafeArea(
              top: false,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(FadGap.lg, kToolbarHeight + 48, FadGap.lg, 140),
                children: [
                  FadBadge(label: '${lesson.durationLabel} · ${lesson.level}', icon: FadIcons.clock, color: c.violet),
                  const SizedBox(height: FadGap.sm),
                  Text(lesson.title, style: t.headlineLarge),
                  const SizedBox(height: FadGap.lg),
                  for (var i = 0; i < lesson.steps.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: FadGap.sm),
                      child: GlassPanel(
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Container(
                            width: 30, height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(gradient: c.brandGradient, shape: BoxShape.circle),
                            child: Text('${i + 1}',
                                style: t.labelLarge?.copyWith(color: c.onPrimary, fontWeight: FontWeight.w800)),
                          ),
                          const SizedBox(width: FadGap.sm),
                          Expanded(child: Text(lesson.steps[i], style: t.bodyLarge)),
                        ]),
                      ),
                    ),
                  const SizedBox(height: FadGap.xs),
                  GlassPanel(
                    glow: true,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Icon(FadIcons.sparkle, color: c.accent, size: 18),
                        const SizedBox(width: 6),
                        Text(l.lessonKeyTakeaway, style: t.titleSmall),
                      ]),
                      const SizedBox(height: FadGap.xs),
                      Text(lesson.takeaway, style: t.bodyLarge?.copyWith(color: c.textMid)),
                    ]),
                  ),
                ],
              ),
            ),
      floatingActionButton: lesson == null
          ? null
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: FadGap.lg),
              child: FadButton(label: l.lessonMarkDone, icon: FadIcons.check, onPressed: () => context.pop()),
            ),
    );
  }
}

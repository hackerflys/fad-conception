import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/demo_data.dart';
import '../../core/data/models.dart';
import '../../core/design/fad_colors.dart';
import '../../core/design/fad_icons.dart';
import '../../core/design/fad_tokens.dart';
import '../../core/widgets/fad_button.dart';
import '../../core/widgets/fad_common.dart';
import '../../core/widgets/glass_panel.dart';
import '../../l10n/l10n_ext.dart';

class SignalDetailScreen extends ConsumerWidget {
  const SignalDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fad;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final signal = signalById(ref, id);

    if (signal == null) {
      return FadScaffold(
        appBar: AppBar(leading: const _BackBtn()),
        body: Center(child: Text(l.stateEmpty, style: t.bodyMedium)),
      );
    }

    return FadScaffold(
      appBar: AppBar(
        leading: const _BackBtn(),
        actions: [
          FadIconButton(icon: FadIcons.bookmark, onTap: () {}),
          const SizedBox(width: FadGap.xs),
          FadIconButton(icon: FadIcons.share, onTap: () => _share(context)),
          const SizedBox(width: FadGap.lg),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(FadGap.lg, kToolbarHeight + 48, FadGap.lg, 140),
          children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(borderRadius: FadRadius.rSm, gradient: c.brandGradient),
                child: Icon(signal.category.icon, color: c.onPrimary, size: 20),
              ),
              const SizedBox(width: FadGap.sm),
              Text(signal.category.label, style: t.titleMedium),
              const Spacer(),
              FadBadge(label: '${signal.localScore} ${l.signalLocalScore}', icon: FadIcons.localScore),
            ]),
            const SizedBox(height: FadGap.md),
            Text(signal.title, style: t.headlineLarge),
            const SizedBox(height: FadGap.lg),
            _Block(icon: FadIcons.clock, title: l.signalIn10s, body: signal.inTenSeconds, accent: true),
            _Block(icon: FadIcons.sparkle, title: l.signalWhy, body: signal.why),
            _Block(icon: FadIcons.proof, title: l.signalProof, body: signal.proof),
            const SizedBox(height: FadGap.sm),
            GlassPanel(
              child: Row(
                children: [
                  Expanded(child: _Trust(on: signal.verified, icon: FadIcons.proof, label: l.signalVerified)),
                  Expanded(child: _Trust(on: signal.aiAssisted, icon: FadIcons.aiAssist, label: l.signalAiAssisted)),
                  Expanded(child: _Trust(on: signal.humanReviewed, icon: FadIcons.shield, label: l.signalHumanReview)),
                ],
              ),
            ),
            if (signal.linkedLessonId != null) ...[
              SectionHeader(title: l.signalLinkedLesson),
              Builder(builder: (context) {
                final lesson = lessonById(ref, signal.linkedLessonId!);
                if (lesson == null) return const SizedBox.shrink();
                return GlassPanel(
                  onTap: () => context.push('/lesson/${lesson.id}'),
                  child: Row(children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: FadRadius.rSm, color: c.violet.withValues(alpha: 0.16)),
                      child: Icon(FadIcons.lesson, color: c.violet),
                    ),
                    const SizedBox(width: FadGap.sm),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(lesson.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: t.titleMedium),
                        Text('${lesson.durationLabel} · ${lesson.level}', style: t.bodySmall),
                      ]),
                    ),
                    Icon(FadIcons.forward, color: c.textLow),
                  ]),
                );
              }),
            ],
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: FadGap.lg),
        child: FadButton(label: l.signalTestNow, icon: FadIcons.test, onPressed: () {}),
      ),
    );
  }

  void _share(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(FadGap.lg),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: context.fad.surfaceBorder, borderRadius: FadRadius.rPill)),
          const SizedBox(height: FadGap.lg),
          Text(context.l10n.actionShare, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: FadGap.md),
          Text('WhatsApp · Telegram · Facebook · X · ${context.l10n.actionOpen}',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: FadGap.lg),
        ]),
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({required this.icon, required this.title, required this.body, this.accent = false});
  final IconData icon;
  final String title;
  final String body;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: FadGap.md),
      child: GlassPanel(
        glow: accent,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, size: 18, color: accent ? c.accent : c.primary),
            const SizedBox(width: 8),
            Text(title, style: t.titleSmall?.copyWith(color: c.textHigh)),
          ]),
          const SizedBox(height: FadGap.xs),
          Text(body, style: t.bodyLarge?.copyWith(color: c.textMid)),
        ]),
      ),
    );
  }
}

class _Trust extends StatelessWidget {
  const _Trust({required this.on, required this.icon, required this.label});
  final bool on;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    return Column(children: [
      Icon(icon, color: on ? c.success : c.textLow, size: 24),
      const SizedBox(height: 6),
      Text(label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: c.textMid)),
    ]);
  }
}

class _BackBtn extends StatelessWidget {
  const _BackBtn();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: FadGap.lg),
      child: FadIconButton(icon: FadIcons.back, onTap: () => context.pop()),
    );
  }
}

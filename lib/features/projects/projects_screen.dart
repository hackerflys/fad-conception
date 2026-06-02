import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/demo_data.dart';
import '../../core/data/models.dart';
import '../../core/design/fad_colors.dart';
import '../../core/design/fad_icons.dart';
import '../../core/design/fad_tokens.dart';
import '../../core/widgets/fad_common.dart';
import '../../core/widgets/glass_panel.dart';
import '../../l10n/l10n_ext.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fad;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final projects = ref.watch(projectsProvider);

    return FadScaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/projects/submit'),
        backgroundColor: c.primary,
        foregroundColor: c.onPrimary,
        icon: const Icon(FadIcons.plus),
        label: Text(l.projectsSubmit, style: t.labelLarge?.copyWith(color: c.onPrimary)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(FadGap.lg, FadGap.sm, FadGap.lg, 140),
          children: [
            Text(l.projectsTitle, style: t.headlineLarge),
            const SizedBox(height: FadGap.md),
            for (final p in projects)
              Padding(
                padding: const EdgeInsets.only(bottom: FadGap.sm),
                child: _ProjectCard(p: p),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.p});
  final Project p;

  String _needLabel(BuildContext ctx, ProjectNeed n) => switch (n) {
        ProjectNeed.testers => ctx.l10n.projectNeedsTesters,
        ProjectNeed.devs => ctx.l10n.projectNeedsDevs,
        ProjectNeed.support => ctx.l10n.projectNeedsSupport,
        ProjectNeed.partners => 'Partenaires',
      };

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    final t = Theme.of(context).textTheme;
    return GlassPanel(
      onTap: () => context.push('/project/${p.id}'),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(borderRadius: FadRadius.rSm, gradient: c.brandGradient),
            child: Icon(p.category.icon, color: c.onPrimary),
          ),
          const SizedBox(width: FadGap.sm),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.name, style: t.titleLarge),
              Text('${p.status} · ${p.author}', style: t.bodySmall),
            ]),
          ),
          FadBadge(label: '${p.supportCount}', icon: FadIcons.fire, color: c.warning),
        ]),
        const SizedBox(height: FadGap.sm),
        Text(p.summary, maxLines: 2, overflow: TextOverflow.ellipsis, style: t.bodyMedium?.copyWith(color: c.textMid)),
        const SizedBox(height: FadGap.sm),
        Wrap(spacing: 6, runSpacing: 6, children: [
          for (final n in p.needs) FadChip(label: _needLabel(context, n)),
        ]),
      ]),
    );
  }
}

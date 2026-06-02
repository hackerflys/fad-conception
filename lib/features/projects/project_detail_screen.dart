import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/demo_data.dart';
import '../../core/data/models.dart';
import '../../core/design/fad_colors.dart';
import '../../core/widgets/duo_icon.dart';
import '../../core/design/fad_icons.dart';
import '../../core/design/fad_tokens.dart';
import '../../core/widgets/fad_button.dart';
import '../../core/widgets/fad_common.dart';
import '../../core/widgets/glass_panel.dart';
import '../../l10n/l10n_ext.dart';

class ProjectDetailScreen extends ConsumerWidget {
  const ProjectDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fad;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final p = ref.watch(projectsProvider).where((e) => e.id == id).firstOrNull;

    return FadScaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: FadGap.lg),
          child: FadIconButton(icon: FadIcons.back, onTap: () => context.pop()),
        ),
        actions: [FadIconButton(icon: FadIcons.share, onTap: () {}), const SizedBox(width: FadGap.lg)],
      ),
      body: p == null
          ? Center(child: Text(l.stateEmpty, style: t.bodyMedium))
          : SafeArea(
              top: false,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(FadGap.lg, kToolbarHeight + 48, FadGap.lg, 140),
                children: [
                  Row(children: [
                    Container(
                      width: 64, height: 64,
                      decoration: BoxDecoration(borderRadius: FadRadius.rMd, gradient: c.brandGradient),
                      child: DuoIcon(p.category.icon, color: c.onPrimary, size: 30),
                    ),
                    const SizedBox(width: FadGap.md),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(p.name, style: t.headlineMedium),
                        Text('${p.status} · ${p.author}', style: t.bodyMedium?.copyWith(color: c.textMid)),
                      ]),
                    ),
                  ]),
                  const SizedBox(height: FadGap.lg),
                  GlassPanel(child: Text(p.summary, style: t.bodyLarge)),
                  SectionHeader(title: l.signalProof),
                  GlassPanel(
                    child: Row(children: [
                      DuoIcon(FadIcons.proof, color: c.accent),
                      const SizedBox(width: FadGap.sm),
                      Expanded(child: Text('Démo + dépôt vérifié', style: t.bodyLarge)),
                    ]),
                  ),
                ],
              ),
            ),
      floatingActionButton: p == null
          ? null
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: FadGap.lg),
              child: Row(children: [
                Expanded(child: FadButton(label: l.projectSupport, icon: FadIcons.fire, onPressed: () {})),
                const SizedBox(width: FadGap.sm),
                Expanded(child: FadButton(label: l.projectJoin, kind: FadButtonKind.soft, onPressed: () {})),
              ]),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/design/fad_colors.dart';
import '../../core/design/fad_icons.dart';
import '../../core/design/fad_tokens.dart';
import '../../core/widgets/duo_icon.dart';
import '../../core/widgets/fad_button.dart';
import '../../core/widgets/fad_common.dart';
import '../../core/widgets/glass_panel.dart';
import '../../l10n/l10n_ext.dart';

class SubmitProjectScreen extends StatelessWidget {
  const SubmitProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;

    Widget field(String label, {int lines = 1, String? icon}) => Padding(
          padding: const EdgeInsets.only(bottom: FadGap.sm),
          child: GlassPanel(
            padding: const EdgeInsets.symmetric(horizontal: FadGap.md, vertical: 4),
            child: TextField(
              maxLines: lines,
              style: t.bodyLarge,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: label,
                icon: icon == null ? null : DuoIcon(icon, color: context.fad.textLow),
              ),
            ),
          ),
        );

    return FadScaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: FadGap.lg),
          child: FadIconButton(icon: FadIcons.back, onTap: () => context.pop()),
        ),
        title: Text(l.submitProjectTitle),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(FadGap.lg, kToolbarHeight + 40, FadGap.lg, 140),
          children: [
            field('Nom du projet', icon: FadIcons.projects),
            field('Catégorie', icon: FadIcons.sparkle),
            field('Statut', icon: FadIcons.clock),
            field('Description courte', lines: 2),
            field('Description longue', lines: 4),
            field('Preuve (lien démo / dépôt)', icon: FadIcons.proof),
            field('Contact', icon: FadIcons.messages),
            const SizedBox(height: FadGap.sm),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: FadGap.lg),
        child: Row(children: [
          Expanded(child: FadButton(label: l.submitDraft, kind: FadButtonKind.ghost, onPressed: () => context.pop())),
          const SizedBox(width: FadGap.sm),
          Expanded(child: FadButton(label: l.submitForReview, icon: FadIcons.check, onPressed: () => context.pop())),
        ]),
      ),
    );
  }
}

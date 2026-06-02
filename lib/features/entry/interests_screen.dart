import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design/fad_colors.dart';
import '../../core/design/fad_icons.dart';
import '../../core/design/fad_tokens.dart';
import '../../core/state/app_settings.dart';
import '../../core/widgets/atom_background.dart';
import '../../core/widgets/fad_button.dart';
import '../../core/widgets/fad_common.dart';
import '../../l10n/l10n_ext.dart';

const _interests = <(String, String, String)>[
  ('ai', 'IA', FadIcons.ai),
  ('dev', 'Développement', FadIcons.code),
  ('cyber', 'Cybersécurité', FadIcons.cyber),
  ('flutter', 'Flutter', FadIcons.mobile),
  ('firebase', 'Firebase', FadIcons.lightning),
  ('supabase', 'Supabase', FadIcons.code),
  ('opensource', 'Open Source', FadIcons.openSource),
  ('design', 'Design', FadIcons.design),
  ('business', 'Business', FadIcons.business),
  ('africa', 'Afrique Tech', FadIcons.africa),
  ('beginner', 'Débutant', FadIcons.sparkle),
  ('cameroon', 'Projets Camerounais', FadIcons.localScore),
];

class InterestsScreen extends ConsumerWidget {
  const InterestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fad;
    final l = context.l10n;
    final selected = ref.watch(settingsProvider).interests;

    return Scaffold(
      body: AtomBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(FadGap.xl, FadGap.xl, FadGap.xl, FadGap.xs),
                child: Text(l.interestsTitle, style: Theme.of(context).textTheme.headlineLarge),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: FadGap.xl),
                child: Text(l.interestsSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: c.textMid)),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(FadGap.xl),
                  child: Wrap(
                    spacing: FadGap.sm,
                    runSpacing: FadGap.sm,
                    children: [
                      for (final it in _interests)
                        FadChip(
                          label: it.$2,
                          icon: it.$3,
                          selected: selected.contains(it.$1),
                          onTap: () => ref.read(settingsProvider.notifier).toggleInterest(it.$1),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(FadGap.xl),
                child: FadButton(
                  label: l.actionContinue,
                  icon: FadIcons.forward,
                  onPressed: () => context.go('/auth'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

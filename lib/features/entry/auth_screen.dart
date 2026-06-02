import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design/fad_colors.dart';
import '../../core/design/fad_icons.dart';
import '../../core/design/fad_tokens.dart';
import '../../core/state/app_settings.dart';
import '../../core/widgets/atom_background.dart';
import '../../core/widgets/fad_button.dart';
import '../../core/widgets/fad_logo.dart';
import '../../l10n/l10n_ext.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  void _enter(BuildContext context, WidgetRef ref, {bool guest = false}) {
    final ctrl = ref.read(settingsProvider.notifier);
    if (guest) ctrl.continueAsGuest();
    ctrl.completeOnboarding();
    context.go('/radar');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fad;
    final l = context.l10n;

    return Scaffold(
      body: AtomBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(FadGap.xl),
            child: Column(
              children: [
                const Spacer(),
                const FadMark(size: 96),
                const SizedBox(height: FadGap.lg),
                Text(l.authTitle, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: FadGap.xs),
                Text(l.authSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: c.textMid)),
                const Spacer(),
                FadButton(
                  label: l.authGoogle,
                  icon: FadIcons.globe,
                  onPressed: () => _enter(context, ref),
                ),
                const SizedBox(height: FadGap.sm),
                FadButton(
                  label: l.authEmail,
                  icon: FadIcons.mail,
                  kind: FadButtonKind.soft,
                  onPressed: () => _enter(context, ref),
                ),
                const SizedBox(height: FadGap.sm),
                FadButton(
                  label: l.authGuest,
                  kind: FadButtonKind.ghost,
                  onPressed: () => _enter(context, ref, guest: true),
                ),
                const SizedBox(height: FadGap.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

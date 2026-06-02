import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design/fad_colors.dart';
import '../../core/design/fad_tokens.dart';
import '../../core/state/app_settings.dart';
import '../../core/widgets/atom_background.dart';
import '../../core/widgets/fad_logo.dart';
import '../../l10n/l10n_ext.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1700), () {
      if (!mounted) return;
      final done = ref.read(settingsProvider).onboardingDone;
      context.go(done ? '/radar' : '/onboarding');
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    return Scaffold(
      body: AtomBackground(
        child: Center(
          child: FadeTransition(
            opacity: _ctrl,
            child: ScaleTransition(
              scale: Tween(begin: 0.85, end: 1.0).animate(
                CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FadMark(size: 132),
                  const SizedBox(height: FadGap.xl),
                  const FadWordmark(),
                  const SizedBox(height: FadGap.xs),
                  Text(context.l10n.tagline,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: c.textMid)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

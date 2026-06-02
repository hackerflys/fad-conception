import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design/fad_colors.dart';
import '../../core/design/fad_icons.dart';
import '../../core/design/fad_tokens.dart';
import '../../core/widgets/atom_background.dart';
import '../../core/widgets/duo_icon.dart';
import '../../core/widgets/fad_button.dart';
import '../../l10n/l10n_ext.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    final l = context.l10n;
    final slides = [
      (FadIcons.radar, l.onboardTitle1, l.onboardBody1),
      (FadIcons.lightning, l.onboardTitle2, l.onboardBody2),
      (FadIcons.projects, l.onboardTitle3, l.onboardBody3),
    ];
    final isLast = _page == slides.length - 1;

    return Scaffold(
      body: AtomBackground(
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(FadGap.sm),
                  child: TextButton(
                    onPressed: () => context.go('/interests'),
                    child: Text(l.actionSkip, style: TextStyle(color: c.textMid)),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: slides.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (_, i) {
                    final s = slides[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: FadGap.xl),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 128,
                            height: 128,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: c.brandGradient,
                              boxShadow: [BoxShadow(color: c.glow, blurRadius: 50, spreadRadius: -8)],
                            ),
                            child: DuoIcon(s.$1, size: 60, color: c.onPrimary),
                          ),
                          const SizedBox(height: FadGap.xxl),
                          Text(s.$2,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: FadGap.md),
                          Text(s.$3,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: c.textMid)),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < slides.length; i++)
                    AnimatedContainer(
                      duration: FadMotion.base,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: i == _page ? 26 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: FadRadius.rPill,
                        gradient: i == _page ? c.brandGradient : null,
                        color: i == _page ? null : c.surfaceBorder,
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(FadGap.xl),
                child: FadButton(
                  label: isLast ? l.actionStart : l.actionNext,
                  icon: isLast ? FadIcons.check : FadIcons.forward,
                  onPressed: () {
                    if (isLast) {
                      context.go('/interests');
                    } else {
                      _controller.nextPage(duration: FadMotion.base, curve: FadMotion.curve);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

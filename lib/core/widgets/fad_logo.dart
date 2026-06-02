import 'package:flutter/material.dart';

import '../design/fad_colors.dart';

/// The atomic mark (image asset) used across splash, headers and empty states.
class FadMark extends StatelessWidget {
  const FadMark({super.key, this.size = 96, this.glow = true});

  final double size;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    return Container(
      width: size,
      height: size,
      decoration: glow
          ? BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: c.glow, blurRadius: size * 0.6, spreadRadius: -size * 0.1),
              ],
            )
          : null,
      child: Image.asset('assets/brand/fad_atom.png', fit: BoxFit.contain),
    );
  }
}

/// Typographic wordmark "FAD Conception" — the name is written, never an image,
/// so it stays crisp and themable.
class FadWordmark extends StatelessWidget {
  const FadWordmark({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    final t = Theme.of(context).textTheme;
    return RichText(
      text: TextSpan(
        style: (compact ? t.titleLarge : t.headlineMedium)?.copyWith(letterSpacing: -0.3),
        children: [
          TextSpan(text: 'FAD', style: TextStyle(color: c.textHigh, fontWeight: FontWeight.w800)),
          TextSpan(text: ' Conception', style: TextStyle(color: c.accent, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../design/fad_colors.dart';

/// Immersive "atomic space" backdrop: a deep vertical gradient, two soft
/// brand-coloured glow blobs and a faint field of orbiting particles.
/// This is what keeps screens from looking like flat boxes — content floats
/// over a living surface rather than sitting on a plain colour.
class AtomBackground extends StatelessWidget {
  const AtomBackground({
    super.key,
    required this.child,
    this.intensity = 1,
  });

  final Widget child;

  /// 0 = almost flat, 1 = full glow. Lower it on dense screens.
  final double intensity;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [c.bgGradientTop, c.bgGradientBottom],
        ),
      ),
      child: CustomPaint(
        painter: _AtomPainter(c, intensity),
        isComplex: true,
        willChange: false,
        child: child,
      ),
    );
  }
}

class _AtomPainter extends CustomPainter {
  _AtomPainter(this.c, this.intensity);

  final FadColors c;
  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    if (intensity <= 0) return;

    // Glow blobs — top-right primary, bottom-left accent.
    void glow(Offset center, double radius, Color color) {
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [color.withValues(alpha: color.a * intensity), color.withValues(alpha: 0)],
        ).createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawCircle(center, radius, paint);
    }

    glow(Offset(size.width * 0.92, size.height * 0.08), size.width * 0.75,
        c.primary.withValues(alpha: c.isDark ? 0.30 : 0.16));
    glow(Offset(size.width * 0.05, size.height * 0.85), size.width * 0.7,
        c.accent.withValues(alpha: c.isDark ? 0.20 : 0.12));

    // Particle field — deterministic so it never flickers between frames.
    final rng = math.Random(42);
    final dot = Paint();
    final particles = (size.width * size.height / 14000).clamp(20, 90).toInt();
    for (var i = 0; i < particles; i++) {
      final dx = rng.nextDouble() * size.width;
      final dy = rng.nextDouble() * size.height;
      final r = rng.nextDouble() * 1.8 + 0.4;
      final a = (rng.nextDouble() * 0.5 + 0.1) * intensity * (c.isDark ? 1 : 0.6);
      dot.color = (rng.nextBool() ? c.accent : c.primary).withValues(alpha: a);
      canvas.drawCircle(Offset(dx, dy), r, dot);
    }

    // Two faint orbital rings near the top — the "atom" motif.
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = c.accent.withValues(alpha: 0.10 * intensity);
    final center = Offset(size.width * 0.85, size.height * 0.06);
    for (final scale in [0.5, 0.8]) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(scale);
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: size.width * scale, height: size.width * scale * 0.4),
        ring,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _AtomPainter old) =>
      old.c != c || old.intensity != intensity;
}

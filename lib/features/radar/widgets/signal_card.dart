import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/models.dart';
import '../../../core/design/fad_colors.dart';
import '../../../core/widgets/duo_icon.dart';
import '../../../core/design/fad_icons.dart';
import '../../../core/design/fad_tokens.dart';
import '../../../core/widgets/glass_panel.dart';

class SignalCard extends StatelessWidget {
  const SignalCard({super.key, required this.signal, this.featured = false});

  final Signal signal;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    final t = Theme.of(context).textTheme;
    return GlassPanel(
      glow: featured,
      strong: featured,
      onTap: () => context.push('/signal/${signal.id}'),
      padding: const EdgeInsets.all(FadGap.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: FadRadius.rSm,
                  color: c.primary.withValues(alpha: 0.14),
                ),
                child: DuoIcon(signal.category.icon, size: 18, color: c.accent),
              ),
              const SizedBox(width: FadGap.xs),
              Text(signal.category.label.toUpperCase(),
                  style: t.labelSmall?.copyWith(color: c.textMid, letterSpacing: 1)),
              const Spacer(),
              DuoIcon(FadIcons.localScore, size: 14, color: c.success),
              const SizedBox(width: 3),
              Text('${signal.localScore}', style: t.labelMedium?.copyWith(color: c.success)),
            ],
          ),
          const SizedBox(height: FadGap.sm),
          Text(signal.title,
              maxLines: featured ? 3 : 2,
              overflow: TextOverflow.ellipsis,
              style: (featured ? t.headlineSmall : t.titleMedium)?.copyWith(height: 1.25)),
          const SizedBox(height: FadGap.xs),
          Text(signal.inTenSeconds,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: t.bodyMedium?.copyWith(color: c.textMid)),
          const SizedBox(height: FadGap.sm),
          Row(
            children: [
              DuoIcon(FadIcons.like, size: 16, color: c.danger),
              const SizedBox(width: 4),
              Text('${signal.likeCount}', style: t.labelSmall),
              const SizedBox(width: FadGap.md),
              DuoIcon(FadIcons.comment, size: 16, color: c.textLow),
              const SizedBox(width: 4),
              Text('${signal.commentCount}', style: t.labelSmall),
              const SizedBox(width: FadGap.md),
              DuoIcon(FadIcons.bookmark, size: 16, color: c.textLow),
              const SizedBox(width: 4),
              Text('${signal.savedCount}', style: t.labelSmall),
              const Spacer(),
              if (signal.verified)
                DuoIcon(FadIcons.proof, size: 18, color: c.accent),
            ],
          ),
        ],
      ),
    );
  }
}

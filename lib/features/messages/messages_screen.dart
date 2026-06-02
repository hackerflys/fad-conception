import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/demo_data.dart';
import '../../core/design/fad_colors.dart';
import '../../core/design/fad_icons.dart';
import '../../core/design/fad_tokens.dart';
import '../../core/widgets/fad_common.dart';
import '../../core/widgets/glass_panel.dart';
import '../../l10n/l10n_ext.dart';

class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.fad;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final conversations = ref.watch(conversationsProvider);

    return FadScaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: FadGap.lg),
          child: FadIconButton(icon: FadIcons.back, onTap: () => context.pop()),
        ),
        title: Text(l.messagesTitle),
      ),
      body: SafeArea(
        top: false,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(FadGap.lg, kToolbarHeight + 40, FadGap.lg, 120),
          itemCount: conversations.length,
          separatorBuilder: (_, __) => const SizedBox(height: FadGap.xs),
          itemBuilder: (_, i) {
            final conv = conversations[i];
            return GlassPanel(
              onTap: () => context.push('/messages/${conv.id}'),
              padding: const EdgeInsets.all(FadGap.sm),
              child: Row(children: [
                Stack(children: [
                  Container(
                    width: 52, height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(shape: BoxShape.circle, gradient: c.brandGradient),
                    child: Text(conv.name.characters.first,
                        style: t.titleLarge?.copyWith(color: c.onPrimary)),
                  ),
                  if (conv.online)
                    Positioned(
                      right: 2, bottom: 2,
                      child: Container(
                        width: 13, height: 13,
                        decoration: BoxDecoration(
                          color: c.success, shape: BoxShape.circle,
                          border: Border.all(color: c.bgBase, width: 2),
                        ),
                      ),
                    ),
                ]),
                const SizedBox(width: FadGap.sm),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(conv.name, style: t.titleMedium, overflow: TextOverflow.ellipsis)),
                      Text(conv.time, style: t.labelSmall),
                    ]),
                    const SizedBox(height: 2),
                    Row(children: [
                      Expanded(
                        child: Text(conv.lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.bodyMedium?.copyWith(
                                color: conv.unread > 0 ? c.textHigh : c.textMid)),
                      ),
                      if (conv.unread > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(gradient: c.brandGradient, borderRadius: FadRadius.rPill),
                          child: Text('${conv.unread}',
                              style: t.labelSmall?.copyWith(color: c.onPrimary, fontWeight: FontWeight.w800)),
                        ),
                    ]),
                  ]),
                ),
              ]),
            );
          },
        ),
      ),
    );
  }
}

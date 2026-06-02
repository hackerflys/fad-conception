import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/demo_data.dart';
import '../../core/data/models.dart';
import '../../core/design/fad_colors.dart';
import '../../core/design/fad_icons.dart';
import '../../core/design/fad_tokens.dart';
import '../../core/widgets/fad_common.dart';
import '../../l10n/l10n_ext.dart';

class ConversationScreen extends ConsumerStatefulWidget {
  const ConversationScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  final _input = TextEditingController();
  late List<ChatMessage> _messages;
  bool _composing = false;

  @override
  void initState() {
    super.initState();
    final conv = conversationById(ref, widget.id);
    _messages = [...?conv?.messages];
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _send(MsgKind kind, {String text = '', String? duration}) {
    setState(() {
      _messages.add(ChatMessage(
        id: 'local_${_messages.length}',
        kind: kind,
        fromMe: true,
        time: 'now',
        text: text,
        durationLabel: duration,
      ));
      if (kind == MsgKind.text) _input.clear();
      _composing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    final t = Theme.of(context).textTheme;
    final conv = conversationById(ref, widget.id);

    return FadScaffold(
      intensity: 0.6,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: FadGap.lg),
          child: FadIconButton(icon: FadIcons.back, onTap: () => context.pop()),
        ),
        titleSpacing: 0,
        title: Row(children: [
          Container(
            width: 38, height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(shape: BoxShape.circle, gradient: c.brandGradient),
            child: Text(conv?.name.characters.first ?? '?', style: t.titleMedium?.copyWith(color: c.onPrimary)),
          ),
          const SizedBox(width: FadGap.xs),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(conv?.name ?? '', style: t.titleMedium, overflow: TextOverflow.ellipsis),
              if (conv?.online ?? false) Text('en ligne', style: t.labelSmall?.copyWith(color: c.success)),
            ]),
          ),
        ]),
        actions: [FadIconButton(icon: FadIcons.video, onTap: () {}), const SizedBox(width: FadGap.lg)],
      ),
      body: SafeArea(
        top: false,
        child: Column(children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.fromLTRB(FadGap.lg, kToolbarHeight + 40, FadGap.lg, FadGap.sm),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _Bubble(msg: _messages[_messages.length - 1 - i]),
            ),
          ),
          _Composer(
            controller: _input,
            composing: _composing,
            onChanged: (v) => setState(() => _composing = v.trim().isNotEmpty),
            onSendText: () {
              final txt = _input.text.trim();
              if (txt.isNotEmpty) _send(MsgKind.text, text: txt);
            },
            onVoice: () => _send(MsgKind.voice, duration: '0:08'),
            onPhoto: () => _send(MsgKind.photo, text: 'Photo'),
            onVideo: () => _send(MsgKind.video, duration: '0:20'),
          ),
        ]),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.msg});
  final ChatMessage msg;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    final t = Theme.of(context).textTheme;
    final me = msg.fromMe;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(FadRadius.md),
      topRight: const Radius.circular(FadRadius.md),
      bottomLeft: Radius.circular(me ? FadRadius.md : 4),
      bottomRight: Radius.circular(me ? 4 : FadRadius.md),
    );

    Widget content;
    switch (msg.kind) {
      case MsgKind.text:
        content = Text(msg.text,
            style: t.bodyLarge?.copyWith(color: me ? c.onPrimary : c.textHigh));
      case MsgKind.voice:
        content = Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(FadIcons.play, size: 26, color: me ? c.onPrimary : c.accent),
          const SizedBox(width: 8),
          Container(width: 90, height: 3, color: (me ? c.onPrimary : c.textMid).withValues(alpha: 0.5)),
          const SizedBox(width: 8),
          Text(msg.durationLabel ?? '', style: t.labelSmall?.copyWith(color: me ? c.onPrimary : c.textMid)),
        ]);
      case MsgKind.photo:
        content = Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(FadIcons.camera, size: 20, color: me ? c.onPrimary : c.accent),
          const SizedBox(width: 8),
          Text(msg.text.isEmpty ? 'Photo' : msg.text,
              style: t.bodyLarge?.copyWith(color: me ? c.onPrimary : c.textHigh)),
        ]);
      case MsgKind.video:
        content = Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(FadIcons.video, size: 20, color: me ? c.onPrimary : c.accent),
          const SizedBox(width: 8),
          Text('Vidéo · ${msg.durationLabel ?? ''}',
              style: t.bodyLarge?.copyWith(color: me ? c.onPrimary : c.textHigh)),
        ]);
    }

    return Align(
      alignment: me ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: FadGap.xs),
        padding: const EdgeInsets.symmetric(horizontal: FadGap.md, vertical: FadGap.sm),
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.74),
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: me ? c.brandGradient : null,
          color: me ? null : c.surface,
          border: me ? null : Border.all(color: c.surfaceBorder),
        ),
        child: content,
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.composing,
    required this.onChanged,
    required this.onSendText,
    required this.onVoice,
    required this.onPhoto,
    required this.onVideo,
  });

  final TextEditingController controller;
  final bool composing;
  final ValueChanged<String> onChanged;
  final VoidCallback onSendText;
  final VoidCallback onVoice;
  final VoidCallback onPhoto;
  final VoidCallback onVideo;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    return Padding(
      padding: const EdgeInsets.fromLTRB(FadGap.lg, 0, FadGap.lg, FadGap.sm),
      child: Row(children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: FadGap.md, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: FadRadius.rPill,
              color: c.surface,
              border: Border.all(color: c.surfaceBorder),
            ),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  minLines: 1,
                  maxLines: 4,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: context.l10n.messageHint,
                    hintStyle: TextStyle(color: c.textLow),
                  ),
                ),
              ),
              if (!composing) ...[
                _MiniBtn(icon: FadIcons.camera, onTap: onPhoto),
                _MiniBtn(icon: FadIcons.video, onTap: onVideo),
              ],
            ]),
          ),
        ),
        const SizedBox(width: FadGap.xs),
        GestureDetector(
          onTap: composing ? onSendText : onVoice,
          child: Container(
            width: 50, height: 50,
            decoration: BoxDecoration(shape: BoxShape.circle, gradient: c.brandGradient,
                boxShadow: [BoxShadow(color: c.glow, blurRadius: 18, spreadRadius: -4)]),
            child: Icon(composing ? FadIcons.send : FadIcons.mic, color: c.onPrimary),
          ),
        ),
      ]),
    );
  }
}

class _MiniBtn extends StatelessWidget {
  const _MiniBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: context.fad.textMid, size: 22),
      visualDensity: VisualDensity.compact,
    );
  }
}

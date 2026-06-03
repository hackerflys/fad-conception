import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/demo_data.dart';
import '../../core/data/models.dart';
import '../../core/design/fad_colors.dart';
import '../../core/widgets/duo_icon.dart';
import '../../core/design/fad_icons.dart';
import '../../core/design/fad_tokens.dart';
import '../../core/widgets/fad_common.dart';
import '../../l10n/l10n_ext.dart';

const _emojis = [
  '😀','😁','😂','🤣','😊','😍','😎','😉','👍','🙏','🔥','🎉',
  '💯','❤️','😅','🤔','👏','🚀','✨','😢','😮','🙌','💪','👌',
  '😴','🤝','📌','✅','⚡','🌍','💡','📱','🥳','😇','🤩','🙈',
];

class ConversationScreen extends ConsumerStatefulWidget {
  const ConversationScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  final _input = TextEditingController();
  final _focus = FocusNode();
  late List<ChatMessage> _messages;
  bool _composing = false;
  bool _showEmoji = false;

  @override
  void initState() {
    super.initState();
    final conv = conversationById(ref, widget.id);
    _messages = [...?conv?.messages];
  }

  @override
  void dispose() {
    _input.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _send(MsgKind kind, {String text = '', String? duration}) {
    setState(() {
      _messages.add(ChatMessage(
        id: 'local_${_messages.length}',
        kind: kind,
        fromMe: true,
        time: _now(),
        text: text,
        durationLabel: duration,
      ));
      if (kind == MsgKind.text) _input.clear();
      _composing = false;
    });
  }

  String _now() {
    final d = TimeOfDay.now();
    return '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  void _toggleEmoji() {
    HapticFeedback.selectionClick();
    setState(() => _showEmoji = !_showEmoji);
    if (_showEmoji) {
      _focus.unfocus();
    } else {
      _focus.requestFocus();
    }
  }

  void _insertEmoji(String e) {
    _input.text += e;
    _input.selection = TextSelection.fromPosition(TextPosition(offset: _input.text.length));
    setState(() => _composing = _input.text.trim().isNotEmpty);
  }

  Future<void> _openAttach() async {
    HapticFeedback.selectionClick();
    final l = context.l10n;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        final c = ctx.fad;
        Widget tile(String icon, String label, Color col, VoidCallback onTap) => ListTile(
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(borderRadius: FadRadius.rSm, color: col.withValues(alpha: 0.16)),
                child: DuoIcon(icon, size: 24, color: col),
              ),
              title: Text(label, style: Theme.of(ctx).textTheme.titleMedium),
              onTap: () {
                Navigator.pop(ctx);
                onTap();
              },
            );
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: FadGap.md),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              tile(FadIcons.gallery, 'Galerie', c.primary, () => _send(MsgKind.photo, text: 'Galerie')),
              tile(FadIcons.camera, l.messagePhoto, c.accent, () => _send(MsgKind.photo, text: 'Photo')),
              tile(FadIcons.video, l.messageVideo, c.violet, () => _send(MsgKind.video, duration: '0:20')),
              tile(FadIcons.file, 'Fichier', c.warning, () => _send(MsgKind.photo, text: 'Fichier')),
            ]),
          ),
        );
      },
    );
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
          Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight + 36, bottom: FadGap.xs),
            child: _DateChip(label: "Aujourd'hui"),
          ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.fromLTRB(FadGap.lg, FadGap.xs, FadGap.lg, FadGap.sm),
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final idx = _messages.length - 1 - i;
                final msg = _messages[idx];
                // Tail only on the last message of a consecutive same-sender run.
                final next = idx + 1 < _messages.length ? _messages[idx + 1] : null;
                final tail = next == null || next.fromMe != msg.fromMe;
                return _Bubble(msg: msg, tail: tail);
              },
            ),
          ),
          _Composer(
            controller: _input,
            focus: _focus,
            composing: _composing,
            emojiOpen: _showEmoji,
            onChanged: (v) => setState(() => _composing = v.trim().isNotEmpty),
            onSendText: () {
              final txt = _input.text.trim();
              if (txt.isNotEmpty) _send(MsgKind.text, text: txt);
            },
            onVoice: () => _send(MsgKind.voice, duration: '0:08'),
            onEmoji: _toggleEmoji,
            onAttach: _openAttach,
            onTapField: () { if (_showEmoji) setState(() => _showEmoji = false); },
          ),
          if (_showEmoji) _EmojiPanel(onPick: _insertEmoji),
        ]),
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: FadGap.md, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: FadRadius.rPill,
          color: c.isDark ? Colors.white.withValues(alpha: 0.08) : c.surface,
          border: Border.all(color: c.surfaceBorder),
        ),
        child: Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: c.textMid)),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.msg, required this.tail});
  final ChatMessage msg;
  final bool tail;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    final t = Theme.of(context).textTheme;
    final me = msg.fromMe;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(FadRadius.lg),
      topRight: const Radius.circular(FadRadius.lg),
      bottomLeft: Radius.circular(me ? FadRadius.lg : (tail ? 5 : FadRadius.lg)),
      bottomRight: Radius.circular(me ? (tail ? 5 : FadRadius.lg) : FadRadius.lg),
    );
    final onBubble = me ? c.onPrimary : c.textHigh;

    Widget content;
    switch (msg.kind) {
      case MsgKind.text:
        content = Text(msg.text, style: t.bodyLarge?.copyWith(color: onBubble));
      case MsgKind.voice:
        content = Row(mainAxisSize: MainAxisSize.min, children: [
          DuoIcon(FadIcons.play, size: 24, color: me ? c.onPrimary : c.accent),
          const SizedBox(width: 8),
          _Waveform(color: (me ? c.onPrimary : c.accent)),
          const SizedBox(width: 8),
          Text(msg.durationLabel ?? '', style: t.labelSmall?.copyWith(color: me ? c.onPrimary : c.textMid)),
        ]);
      case MsgKind.photo:
        content = Row(mainAxisSize: MainAxisSize.min, children: [
          DuoIcon(FadIcons.gallery, size: 20, color: me ? c.onPrimary : c.accent),
          const SizedBox(width: 8),
          Text(msg.text.isEmpty ? 'Photo' : msg.text, style: t.bodyLarge?.copyWith(color: onBubble)),
        ]);
      case MsgKind.video:
        content = Row(mainAxisSize: MainAxisSize.min, children: [
          DuoIcon(FadIcons.video, size: 20, color: me ? c.onPrimary : c.accent),
          const SizedBox(width: 8),
          Text('Vidéo · ${msg.durationLabel ?? ''}', style: t.bodyLarge?.copyWith(color: onBubble)),
        ]);
    }

    return Align(
      alignment: me ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: tail ? FadGap.sm : 3),
        padding: const EdgeInsets.fromLTRB(FadGap.md, FadGap.xs + 2, FadGap.md, FadGap.xs),
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.76),
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: me ? c.brandGradient : null,
          color: me ? null : (c.isDark ? Colors.white.withValues(alpha: 0.06) : c.surface),
          border: me ? null : Border.all(color: c.surfaceBorder),
          boxShadow: me
              ? [BoxShadow(color: c.glow, blurRadius: 16, spreadRadius: -6, offset: const Offset(0, 6))]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            content,
            const SizedBox(height: 2),
            Text(msg.time,
                style: t.labelSmall?.copyWith(
                    fontSize: 10, color: (me ? c.onPrimary : c.textLow).withValues(alpha: 0.8))),
          ],
        ),
      ),
    );
  }
}

class _Waveform extends StatelessWidget {
  const _Waveform({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    const bars = [6.0, 12.0, 8.0, 16.0, 10.0, 18.0, 9.0, 14.0, 7.0, 12.0, 6.0];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final h in bars)
          Container(
            width: 3,
            height: h,
            margin: const EdgeInsets.symmetric(horizontal: 1.2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.85),
              borderRadius: const BorderRadius.all(Radius.circular(2)),
            ),
          ),
      ],
    );
  }
}

class _EmojiPanel extends StatelessWidget {
  const _EmojiPanel({required this.onPick});
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    return Container(
      height: 240,
      decoration: BoxDecoration(
        color: c.isDark ? const Color(0xFF0A1A30) : Colors.white,
        border: Border(top: BorderSide(color: c.surfaceBorder)),
      ),
      child: GridView.count(
        crossAxisCount: 8,
        padding: const EdgeInsets.all(FadGap.sm),
        children: [
          for (final e in _emojis)
            InkWell(
              borderRadius: FadRadius.rSm,
              onTap: () {
                HapticFeedback.selectionClick();
                onPick(e);
              },
              child: Center(child: Text(e, style: const TextStyle(fontSize: 24))),
            ),
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.focus,
    required this.composing,
    required this.emojiOpen,
    required this.onChanged,
    required this.onSendText,
    required this.onVoice,
    required this.onEmoji,
    required this.onAttach,
    required this.onTapField,
  });

  final TextEditingController controller;
  final FocusNode focus;
  final bool composing;
  final bool emojiOpen;
  final ValueChanged<String> onChanged;
  final VoidCallback onSendText;
  final VoidCallback onVoice;
  final VoidCallback onEmoji;
  final VoidCallback onAttach;
  final VoidCallback onTapField;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    return Padding(
      padding: const EdgeInsets.fromLTRB(FadGap.lg, 0, FadGap.lg, FadGap.sm),
      child: Row(children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: FadRadius.rPill,
              color: c.isDark ? Colors.white.withValues(alpha: 0.06) : c.surface,
              border: Border.all(color: c.surfaceBorder),
            ),
            child: Row(children: [
              _MiniBtn(icon: emojiOpen ? FadIcons.close : FadIcons.emoji, onTap: onEmoji),
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focus,
                  onChanged: onChanged,
                  onTap: onTapField,
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
              _MiniBtn(icon: FadIcons.attach, onTap: onAttach),
            ]),
          ),
        ),
        const SizedBox(width: FadGap.xs),
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            composing ? onSendText() : onVoice();
          },
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: c.brandGradient,
              boxShadow: [BoxShadow(color: c.glow, blurRadius: 16, spreadRadius: -5)],
            ),
            child: DuoIcon(composing ? FadIcons.send : FadIcons.mic, size: 21, color: c.onPrimary),
          ),
        ),
      ]),
    );
  }
}

class _MiniBtn extends StatelessWidget {
  const _MiniBtn({required this.icon, required this.onTap});
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: DuoIcon(icon, color: context.fad.textMid, size: 22),
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
      padding: EdgeInsets.zero,
    );
  }
}

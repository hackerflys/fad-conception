import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/data/demo_data.dart';
import '../../core/data/models.dart';
import '../../core/design/fad_colors.dart';
import '../../core/widgets/duo_icon.dart';
import '../../core/design/fad_icons.dart';
import '../../core/design/fad_tokens.dart';
import '../../core/widgets/fad_common.dart';
import '../../l10n/l10n_ext.dart';

const _quickReactions = ['👍', '❤️', '😂', '😮', '😢', '🙏'];

class _Emo {
  const _Emo(this.e, this.k);
  final String e;
  final String k;
}

const _emojiCats = <String, List<_Emo>>{
  'Smileys': [
    _Emo('😀', 'grin sourire'), _Emo('😁', 'grin'), _Emo('😂', 'rire joy'),
    _Emo('🤣', 'rire'), _Emo('😊', 'content'), _Emo('😍', 'amour love'),
    _Emo('😎', 'cool'), _Emo('😉', 'clin'), _Emo('🥳', 'fete party'),
    _Emo('😇', 'ange'), _Emo('🤩', 'star'), _Emo('😴', 'dormir sleep'),
    _Emo('🤔', 'penser think'), _Emo('😅', 'sueur'), _Emo('🙈', 'singe'),
    _Emo('😢', 'triste cry'), _Emo('😮', 'wow surprise'), _Emo('😋', 'miam'),
  ],
  'Gestes': [
    _Emo('👍', 'pouce ok like'), _Emo('👎', 'dislike'), _Emo('🙏', 'merci priere'),
    _Emo('👏', 'bravo clap'), _Emo('🙌', 'hourra'), _Emo('💪', 'force muscle'),
    _Emo('👌', 'parfait ok'), _Emo('🤝', 'deal main'), _Emo('✌️', 'paix'),
    _Emo('🤙', 'call'), _Emo('👋', 'salut bye'), _Emo('🫶', 'amour'),
  ],
  'Cœurs': [
    _Emo('❤️', 'coeur amour'), _Emo('🧡', 'coeur'), _Emo('💛', 'coeur'),
    _Emo('💚', 'coeur'), _Emo('💙', 'coeur'), _Emo('💜', 'coeur'),
    _Emo('🖤', 'coeur noir'), _Emo('💯', 'cent top'), _Emo('💥', 'boom'),
  ],
  'Tech': [
    _Emo('🔥', 'feu fire hot'), _Emo('✨', 'etincelle'), _Emo('🚀', 'fusee rocket'),
    _Emo('💡', 'idee'), _Emo('📱', 'phone tel'), _Emo('💻', 'pc code'),
    _Emo('⚡', 'eclair'), _Emo('🌍', 'monde terre'), _Emo('🤖', 'robot ia ai'),
    _Emo('✅', 'check ok valide'), _Emo('📌', 'epingle'), _Emo('🎯', 'cible'),
  ],
};

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
  bool _recording = false;
  bool _recPaused = false;
  int _recSecs = 0;
  Timer? _recTimer;
  final Set<String> _playing = {};

  @override
  void initState() {
    super.initState();
    final conv = conversationById(ref, widget.id);
    _messages = [...?conv?.messages];
  }

  @override
  void dispose() {
    _recTimer?.cancel();
    _input.dispose();
    _focus.dispose();
    super.dispose();
  }

  String _now() {
    final d = TimeOfDay.now();
    return '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  void _send(MsgKind kind, {String text = '', String? duration}) {
    setState(() {
      _messages.add(ChatMessage(
        id: 'local_${DateTime.now().microsecondsSinceEpoch}',
        kind: kind,
        fromMe: true,
        time: _now(),
        text: text,
        durationLabel: duration,
        status: MsgStatus.sent,
      ));
      if (kind == MsgKind.text) _input.clear();
      _composing = false;
    });
    // Simulate delivery then read receipts.
    final id = _messages.last.id;
    Future.delayed(const Duration(milliseconds: 700), () => _setStatus(id, MsgStatus.delivered));
    Future.delayed(const Duration(milliseconds: 1800), () => _setStatus(id, MsgStatus.read));
  }

  void _setStatus(String id, MsgStatus s) {
    if (!mounted) return;
    final i = _messages.indexWhere((m) => m.id == id);
    if (i < 0) return;
    setState(() => _messages[i] = _messages[i].copyWith(status: s));
  }

  Future<void> _startRecording() async {
    HapticFeedback.mediumImpact();
    final status = await Permission.microphone.request();
    if (!mounted) return;
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Permission micro refusée')));
      return;
    }
    _focus.unfocus();
    setState(() {
      _showEmoji = false;
      _recording = true;
      _recPaused = false;
      _recSecs = 0;
    });
    _recTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _recPaused) return;
      setState(() => _recSecs++);
    });
  }

  void _togglePauseRecording() {
    HapticFeedback.selectionClick();
    setState(() => _recPaused = !_recPaused);
  }

  void _stopRecording({required bool send}) {
    _recTimer?.cancel();
    final secs = _recSecs;
    setState(() => _recording = false);
    if (send && secs > 0) {
      final m = (secs ~/ 60).toString();
      final s = (secs % 60).toString().padLeft(2, '0');
      _send(MsgKind.voice, duration: '$m:$s');
    }
  }

  void _toggleEmoji() {
    HapticFeedback.selectionClick();
    setState(() => _showEmoji = !_showEmoji);
    _showEmoji ? _focus.unfocus() : _focus.requestFocus();
  }

  void _insertEmoji(String e) {
    _input.text += e;
    _input.selection = TextSelection.fromPosition(TextPosition(offset: _input.text.length));
    setState(() => _composing = _input.text.trim().isNotEmpty);
  }

  void _backspace() {
    final txt = _input.text;
    if (txt.isEmpty) return;
    final chars = txt.characters;
    _input.text = chars.take(chars.length - 1).toString();
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
                width: 44, height: 44,
                decoration: BoxDecoration(borderRadius: FadRadius.rSm, color: col.withValues(alpha: 0.16)),
                child: DuoIcon(icon, size: 24, color: col),
              ),
              title: Text(label, style: Theme.of(ctx).textTheme.titleMedium),
              onTap: () { Navigator.pop(ctx); onTap(); },
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

  void _setReaction(ChatMessage msg, String emoji) {
    final i = _messages.indexWhere((m) => m.id == msg.id);
    if (i < 0) return;
    HapticFeedback.selectionClick();
    setState(() {
      final same = _messages[i].reaction == emoji;
      _messages[i] = _messages[i].copyWith(reaction: same ? null : emoji, clearReaction: same);
    });
  }

  void _deleteMsg(ChatMessage msg) {
    HapticFeedback.mediumImpact();
    setState(() => _messages.removeWhere((m) => m.id == msg.id));
  }

  void _editMsg(ChatMessage msg) {
    if (msg.kind != MsgKind.text) return;
    _input.text = msg.text;
    _input.selection = TextSelection.fromPosition(TextPosition(offset: _input.text.length));
    setState(() {
      _messages.removeWhere((m) => m.id == msg.id);
      _composing = _input.text.trim().isNotEmpty;
    });
    _focus.requestFocus();
  }

  Future<void> _openMessageOptions(ChatMessage msg) async {
    HapticFeedback.mediumImpact();
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        final c = ctx.fad;
        Widget opt(String icon, String label, VoidCallback onTap, {Color? col}) => ListTile(
              leading: DuoIcon(icon, size: 24, color: col ?? c.textHigh),
              title: Text(label, style: Theme.of(ctx).textTheme.titleMedium?.copyWith(color: col)),
              onTap: () { Navigator.pop(ctx); onTap(); },
            );
        void snack(String s) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
        return SafeArea(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            // Quick reactions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: FadGap.lg, vertical: FadGap.xs),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (final r in _quickReactions)
                    GestureDetector(
                      onTap: () { Navigator.pop(ctx); _setReaction(msg, r); },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: msg.reaction == r ? c.primary.withValues(alpha: 0.2) : Colors.transparent,
                        ),
                        child: Text(r, style: const TextStyle(fontSize: 26)),
                      ),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            opt(FadIcons.reply, 'Répondre', () => snack('Répondre')),
            if (msg.fromMe && msg.kind == MsgKind.text) opt(FadIcons.edit, 'Modifier', () => _editMsg(msg)),
            opt(FadIcons.forwardMsg, 'Transférer', () => snack('Transféré')),
            opt(FadIcons.archive, 'Archiver', () => snack('Archivé')),
            opt(FadIcons.trash, 'Supprimer', () => _deleteMsg(msg), col: c.danger),
            const SizedBox(height: FadGap.xs),
          ]),
        );
      },
    );
  }

  void _togglePlay(ChatMessage msg) {
    HapticFeedback.selectionClick();
    setState(() => _playing.contains(msg.id) ? _playing.remove(msg.id) : _playing.add(msg.id));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    final t = Theme.of(context).textTheme;
    final conv = conversationById(ref, widget.id);

    return FadScaffold(
      intensity: 0.5,
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
            child: const _DateChip(label: "Aujourd'hui"),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () { if (_showEmoji) setState(() => _showEmoji = false); _focus.unfocus(); },
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.fromLTRB(FadGap.lg, FadGap.xs, FadGap.lg, FadGap.sm),
                itemCount: _messages.length,
                itemBuilder: (_, i) {
                  final idx = _messages.length - 1 - i;
                  final msg = _messages[idx];
                  final next = idx + 1 < _messages.length ? _messages[idx + 1] : null;
                  final tail = next == null || next.fromMe != msg.fromMe;
                  return _Bubble(
                    msg: msg,
                    tail: tail,
                    playing: _playing.contains(msg.id),
                    onPlay: () => _togglePlay(msg),
                    onLongPress: () => _openMessageOptions(msg),
                  );
                },
              ),
            ),
          ),
          if (_recording)
            _RecordingBar(
              seconds: _recSecs,
              paused: _recPaused,
              onPauseToggle: _togglePauseRecording,
              onCancel: () => _stopRecording(send: false),
              onSend: () => _stopRecording(send: true),
            )
          else
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
              onVoice: _startRecording,
              onEmoji: _toggleEmoji,
              onAttach: _openAttach,
              onTapField: () { if (_showEmoji) setState(() => _showEmoji = false); },
            ),
          if (_showEmoji && !_recording)
            _EmojiPanel(onPick: _insertEmoji, onBackspace: _backspace),
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
  const _Bubble({
    required this.msg,
    required this.tail,
    required this.playing,
    required this.onPlay,
    required this.onLongPress,
  });
  final ChatMessage msg;
  final bool tail;
  final bool playing;
  final VoidCallback onPlay;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    final t = Theme.of(context).textTheme;
    final me = msg.fromMe;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(FadRadius.lg),
      topRight: const Radius.circular(FadRadius.lg),
      bottomLeft: Radius.circular(me ? FadRadius.lg : (tail ? 6 : FadRadius.lg)),
      bottomRight: Radius.circular(me ? (tail ? 6 : FadRadius.lg) : FadRadius.lg),
    );
    final onBubble = me ? c.onPrimary : c.textHigh;
    final read = msg.status == MsgStatus.read;
    // Voice player colour changes once the note is "read".
    final voiceColor = me ? c.onPrimary : (read ? c.accent : c.textMid);

    Widget content;
    switch (msg.kind) {
      case MsgKind.text:
        content = Text(msg.text, style: t.bodyLarge?.copyWith(color: onBubble));
      case MsgKind.voice:
        content = Row(mainAxisSize: MainAxisSize.min, children: [
          GestureDetector(
            onTap: onPlay,
            child: Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: voiceColor.withValues(alpha: me ? 0.22 : 0.16),
              ),
              child: DuoIcon(playing ? FadIcons.pause : FadIcons.playFill, size: 18, color: voiceColor),
            ),
          ),
          const SizedBox(width: 8),
          _Waveform(color: voiceColor),
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

    final bubble = GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.only(bottom: msg.reaction != null ? FadGap.md : (tail ? FadGap.sm : 3)),
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
            Row(mainAxisSize: MainAxisSize.min, children: [
              Text(msg.time,
                  style: t.labelSmall?.copyWith(
                      fontSize: 10, color: (me ? c.onPrimary : c.textLow).withValues(alpha: 0.8))),
              if (me) ...[
                const SizedBox(width: 4),
                Text(
                  msg.status == MsgStatus.sent ? '✓' : '✓✓',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1,
                    color: msg.status == MsgStatus.read ? c.accent : c.onPrimary.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ]),
          ],
        ),
      ),
    );

    return Align(
      alignment: me ? Alignment.centerRight : Alignment.centerLeft,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          bubble,
          if (msg.reaction != null)
            Positioned(
              bottom: -2,
              right: me ? 10 : null,
              left: me ? null : 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  borderRadius: FadRadius.rPill,
                  color: c.isDark ? c.bgGradientTop : Colors.white,
                  border: Border.all(color: c.surfaceBorder),
                ),
                child: Text(msg.reaction!, style: const TextStyle(fontSize: 13)),
              ),
            ),
        ],
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

class _EmojiPanel extends StatefulWidget {
  const _EmojiPanel({required this.onPick, required this.onBackspace});
  final ValueChanged<String> onPick;
  final VoidCallback onBackspace;

  @override
  State<_EmojiPanel> createState() => _EmojiPanelState();
}

class _EmojiPanelState extends State<_EmojiPanel> {
  String _cat = _emojiCats.keys.first;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    final t = Theme.of(context).textTheme;
    final List<_Emo> items = _query.trim().isEmpty
        ? _emojiCats[_cat]!
        : [
            for (final list in _emojiCats.values)
              ...list.where((e) => e.k.contains(_query.trim().toLowerCase()))
          ];

    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: c.isDark ? const Color(0xFF0A1A30) : Colors.white,
        border: Border(top: BorderSide(color: c.surfaceBorder)),
      ),
      child: Column(children: [
        // Search row + backspace
        Padding(
          padding: const EdgeInsets.fromLTRB(FadGap.sm, FadGap.xs, FadGap.sm, 0),
          child: Row(children: [
            Expanded(
              child: Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: FadGap.sm),
                decoration: BoxDecoration(
                  borderRadius: FadRadius.rPill,
                  color: c.isDark ? Colors.white.withValues(alpha: 0.06) : c.surface,
                  border: Border.all(color: c.surfaceBorder),
                ),
                child: Row(children: [
                  DuoIcon(FadIcons.search, size: 18, color: c.textMid),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _query = v),
                      style: t.bodyMedium?.copyWith(color: c.textHigh),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        hintText: 'Rechercher un emoji',
                        hintStyle: TextStyle(color: c.textLow),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            IconButton(
              onPressed: () { HapticFeedback.selectionClick(); widget.onBackspace(); },
              icon: DuoIcon(FadIcons.back, size: 22, color: c.textMid),
            ),
          ]),
        ),
        // Category tabs
        if (_query.trim().isEmpty)
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: FadGap.sm),
              children: [
                for (final cat in _emojiCats.keys)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FadChip(label: cat, selected: cat == _cat, onTap: () => setState(() => _cat = cat)),
                  ),
              ],
            ),
          ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 8,
            padding: const EdgeInsets.all(FadGap.sm),
            children: [
              for (final e in items)
                InkWell(
                  borderRadius: FadRadius.rSm,
                  onTap: () { HapticFeedback.selectionClick(); widget.onPick(e.e); },
                  child: Center(child: Text(e.e, style: const TextStyle(fontSize: 24))),
                ),
            ],
          ),
        ),
      ]),
    );
  }
}

class _RecordingBar extends StatelessWidget {
  const _RecordingBar({
    required this.seconds,
    required this.paused,
    required this.onPauseToggle,
    required this.onCancel,
    required this.onSend,
  });
  final int seconds;
  final bool paused;
  final VoidCallback onPauseToggle;
  final VoidCallback onCancel;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final c = context.fad;
    final t = Theme.of(context).textTheme;
    final m = (seconds ~/ 60).toString();
    final s = (seconds % 60).toString().padLeft(2, '0');
    return Padding(
      padding: const EdgeInsets.fromLTRB(FadGap.lg, 0, FadGap.lg, FadGap.sm),
      child: Row(children: [
        // Delete
        GestureDetector(
          onTap: () { HapticFeedback.mediumImpact(); onCancel(); },
          child: DuoIcon(FadIcons.trash, size: 24, color: c.danger),
        ),
        const SizedBox(width: FadGap.sm),
        Expanded(
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: FadGap.md),
            decoration: BoxDecoration(
              borderRadius: FadRadius.rPill,
              color: c.isDark ? Colors.white.withValues(alpha: 0.06) : c.surface,
              border: Border.all(color: c.danger.withValues(alpha: 0.4)),
            ),
            child: Row(children: [
              Container(
                width: 11, height: 11,
                decoration: BoxDecoration(
                  color: paused ? c.textMid : c.danger,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: FadGap.sm),
              Text('$m:$s', style: t.titleMedium?.copyWith(color: c.textHigh)),
              const SizedBox(width: FadGap.sm),
              Expanded(child: _Waveform(color: paused ? c.textMid : c.danger)),
              GestureDetector(
                onTap: onPauseToggle,
                child: DuoIcon(paused ? FadIcons.playFill : FadIcons.pause, size: 24, color: c.accent),
              ),
            ]),
          ),
        ),
        const SizedBox(width: FadGap.xs),
        GestureDetector(
          onTap: () { HapticFeedback.lightImpact(); onSend(); },
          child: Container(
            width: 46, height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: c.brandGradient,
              boxShadow: [BoxShadow(color: c.glow, blurRadius: 16, spreadRadius: -5)],
            ),
            child: Center(child: DuoIcon(FadIcons.send, size: 19, color: c.onPrimary)),
          ),
        ),
      ]),
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
          onTap: () { HapticFeedback.lightImpact(); composing ? onSendText() : onVoice(); },
          child: Container(
            width: 46, height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: c.brandGradient,
              boxShadow: [BoxShadow(color: c.glow, blurRadius: 16, spreadRadius: -5)],
            ),
            child: Center(child: DuoIcon(composing ? FadIcons.send : FadIcons.mic, size: 19, color: c.onPrimary)),
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

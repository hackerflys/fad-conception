import '../design/fad_icons.dart';

/// Lightweight immutable domain models for the MVP. The store layer is in-memory
/// demo data today and can be swapped for Supabase without touching the UI.

enum SignalCategory { ai, dev, cyber, mobile, design, business, africa }

extension SignalCategoryX on SignalCategory {
  String get label => switch (this) {
        SignalCategory.ai => 'IA',
        SignalCategory.dev => 'Dev',
        SignalCategory.cyber => 'Cyber',
        SignalCategory.mobile => 'Mobile',
        SignalCategory.design => 'Design',
        SignalCategory.business => 'Business',
        SignalCategory.africa => 'Afrique Tech',
      };

  String get icon => switch (this) {
        SignalCategory.ai => FadIcons.ai,
        SignalCategory.dev => FadIcons.code,
        SignalCategory.cyber => FadIcons.cyber,
        SignalCategory.mobile => FadIcons.mobile,
        SignalCategory.design => FadIcons.design,
        SignalCategory.business => FadIcons.business,
        SignalCategory.africa => FadIcons.africa,
      };
}

class Signal {
  const Signal({
    required this.id,
    required this.title,
    required this.category,
    required this.inTenSeconds,
    required this.why,
    required this.proof,
    required this.localScore,
    required this.savedCount,
    required this.commentCount,
    this.likeCount = 0,
    this.verified = true,
    this.aiAssisted = true,
    this.humanReviewed = true,
    this.linkedLessonId,
  });

  final String id;
  final String title;
  final SignalCategory category;
  final String inTenSeconds;
  final String why;
  final String proof;
  final int localScore; // 0..100
  final int savedCount;
  final int commentCount;
  final int likeCount;
  final bool verified;
  final bool aiAssisted;
  final bool humanReviewed;
  final String? linkedLessonId;
}

class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.durationLabel,
    required this.level,
    required this.steps,
    required this.takeaway,
    this.done = false,
  });

  final String id;
  final String title;
  final String durationLabel;
  final String level;
  final List<String> steps;
  final String takeaway;
  final bool done;
}

class Series {
  const Series({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.episodes,
    required this.progress,
  });

  final String id;
  final String title;
  final String description;
  final String level;
  final int episodes;
  final double progress; // 0..1
}

enum ProjectNeed { testers, devs, support, partners }

class Project {
  const Project({
    required this.id,
    required this.name,
    required this.status,
    required this.author,
    required this.summary,
    required this.category,
    required this.needs,
    required this.supportCount,
  });

  final String id;
  final String name;
  final String status;
  final String author;
  final String summary;
  final SignalCategory category;
  final List<ProjectNeed> needs;
  final int supportCount;
}

enum MsgKind { text, voice, photo, video }

enum MsgStatus { sent, delivered, read }

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.kind,
    required this.fromMe,
    required this.time,
    this.text = '',
    this.durationLabel,
    this.status = MsgStatus.read,
    this.reaction,
  });

  final String id;
  final MsgKind kind;
  final bool fromMe;
  final String time;
  final String text;
  final String? durationLabel; // voice / video length
  final MsgStatus status;
  final String? reaction; // single emoji reaction

  ChatMessage copyWith({MsgStatus? status, String? reaction, bool clearReaction = false}) {
    return ChatMessage(
      id: id,
      kind: kind,
      fromMe: fromMe,
      time: time,
      text: text,
      durationLabel: durationLabel,
      status: status ?? this.status,
      reaction: clearReaction ? null : (reaction ?? this.reaction),
    );
  }
}

class Conversation {
  const Conversation({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unread,
    required this.online,
    required this.messages,
  });

  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int unread;
  final bool online;
  final List<ChatMessage> messages;
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models.dart';

/// In-memory demo content. Replace these providers with Supabase queries later.

const _signals = <Signal>[
  Signal(
    id: 's1',
    title: 'Un modèle IA léger tourne maintenant hors-ligne sur un téléphone',
    category: SignalCategory.ai,
    inTenSeconds:
        'Un petit modèle ouvert répond à des questions sans connexion, directement sur un mobile d\'entrée de gamme.',
    why:
        'Pour le Cameroun, faire tourner l\'IA hors-ligne réduit les coûts de données et fonctionne là où le réseau est faible.',
    proof: 'Démo publique + dépôt open source avec instructions reproductibles.',
    localScore: 92,
    savedCount: 248,
    commentCount: 31,
    likeCount: 530,
    linkedLessonId: 'l1',
  ),
  Signal(
    id: 's2',
    title: 'Supabase ajoute des sauvegardes automatiques sur le plan gratuit',
    category: SignalCategory.dev,
    inTenSeconds: 'Les projets gratuits gardent désormais un historique de restauration de 7 jours.',
    why: 'Moins de risque de perdre la base d\'un projet étudiant ou d\'une petite équipe.',
    proof: 'Annonce officielle + changelog daté.',
    localScore: 78,
    savedCount: 132,
    commentCount: 12,
    likeCount: 312,
    linkedLessonId: 'l2',
  ),
  Signal(
    id: 's3',
    title: 'Une faille fréquente sur les apps mobiles : les clés API en clair',
    category: SignalCategory.cyber,
    inTenSeconds: 'Beaucoup d\'apps stockent encore des clés sensibles directement dans le code.',
    why: 'Un débutant peut exposer sa base ou son budget cloud sans s\'en rendre compte.',
    proof: 'Étude sécurité + exemples anonymisés vérifiés.',
    localScore: 85,
    savedCount: 176,
    commentCount: 24,
    likeCount: 410,
  ),
  Signal(
    id: 's4',
    title: 'Flutter accélère le rendu sur les appareils Android modestes',
    category: SignalCategory.mobile,
    inTenSeconds: 'Le nouveau moteur réduit les saccades sur les téléphones bas de gamme.',
    why: 'L\'expérience devient fluide pour la majorité des utilisateurs au Cameroun.',
    proof: 'Benchmarks officiels reproduits par la communauté.',
    localScore: 88,
    savedCount: 201,
    commentCount: 18,
    likeCount: 487,
    linkedLessonId: 'l1',
  ),
];

const _lessons = <Lesson>[
  Lesson(
    id: 'l1',
    title: 'Lancer ta première app Flutter en 60 secondes',
    durationLabel: '1 min',
    level: 'Débutant',
    steps: [
      'Installe le SDK Flutter et vérifie avec flutter doctor.',
      'Crée un projet : flutter create mon_app.',
      'Lance-le : flutter run sur un appareil ou émulateur.',
      'Modifie le texte de la page d\'accueil et observe le hot reload.',
    ],
    takeaway: 'Tu peux voir une vraie app tourner en quelques minutes, sans matériel coûteux.',
  ),
  Lesson(
    id: 'l2',
    title: 'Comprendre Supabase en 5 idées simples',
    durationLabel: '1 min',
    level: 'Débutant',
    steps: [
      'Supabase = base de données + authentification + stockage.',
      'Tout repose sur PostgreSQL, une base solide et gratuite.',
      'Les règles RLS protègent chaque ligne de données.',
      'Le temps réel pousse les changements aux clients.',
    ],
    takeaway: 'Supabase couvre l\'essentiel d\'un back-end sans serveur à gérer soi-même.',
  ),
];

const _series = <Series>[
  Series(
    id: 'se1',
    title: 'IA pour débutants',
    description: 'Comprendre l\'IA sans mathématiques, étape par étape.',
    level: 'Débutant',
    episodes: 6,
    progress: 0.33,
  ),
  Series(
    id: 'se2',
    title: 'Créer une app avec Flutter',
    description: 'De l\'idée à une première app publiée.',
    level: 'Intermédiaire',
    episodes: 8,
    progress: 0.12,
  ),
  Series(
    id: 'se3',
    title: 'Projets camerounais à découvrir',
    description: 'Des builders locaux et ce qu\'on peut en apprendre.',
    level: 'Tous niveaux',
    episodes: 5,
    progress: 0,
  ),
];

const _projects = <Project>[
  Project(
    id: 'p1',
    name: 'AgriPredict',
    status: 'Prototype',
    author: 'Awa N.',
    summary: 'Prévoir les maladies des cultures à partir de photos prises au champ.',
    category: SignalCategory.ai,
    needs: [ProjectNeed.testers, ProjectNeed.devs],
    supportCount: 64,
  ),
  Project(
    id: 'p2',
    name: 'SafeRoute237',
    status: 'En cours',
    author: 'Jean K.',
    summary: 'Signaler en temps réel l\'état des routes et les zones à risque.',
    category: SignalCategory.mobile,
    needs: [ProjectNeed.support, ProjectNeed.partners],
    supportCount: 41,
  ),
  Project(
    id: 'p3',
    name: 'LinguaCam',
    status: 'Idée validée',
    author: 'Mireille T.',
    summary: 'Apprendre les langues locales avec des mini-leçons audio.',
    category: SignalCategory.africa,
    needs: [ProjectNeed.testers, ProjectNeed.support],
    supportCount: 88,
  ),
];

const _conversations = <Conversation>[
  Conversation(
    id: 'c1',
    name: 'Awa N.',
    lastMessage: 'On teste AgriPredict ce week-end ?',
    time: '09:24',
    unread: 2,
    online: true,
    messages: [
      ChatMessage(id: 'm1', kind: MsgKind.text, fromMe: false, time: '09:20', text: 'Salut ! Tu as vu le signal IA hors-ligne ?'),
      ChatMessage(id: 'm2', kind: MsgKind.text, fromMe: true, time: '09:21', text: 'Oui, énorme pour nos zones à faible réseau.'),
      ChatMessage(id: 'm3', kind: MsgKind.voice, fromMe: false, time: '09:22', durationLabel: '0:14'),
      ChatMessage(id: 'm4', kind: MsgKind.photo, fromMe: true, time: '09:23', text: 'Capture du proto'),
      ChatMessage(id: 'm5', kind: MsgKind.text, fromMe: false, time: '09:24', text: 'On teste AgriPredict ce week-end ?'),
    ],
  ),
  Conversation(
    id: 'c2',
    name: 'Équipe FAD',
    lastMessage: 'Nouveau signal validé 🎉',
    time: 'Hier',
    unread: 0,
    online: false,
    messages: [
      ChatMessage(id: 'm1', kind: MsgKind.text, fromMe: false, time: 'Hier', text: 'Nouveau signal validé 🎉'),
      ChatMessage(id: 'm2', kind: MsgKind.video, fromMe: false, time: 'Hier', durationLabel: '0:45'),
    ],
  ),
  Conversation(
    id: 'c3',
    name: 'Jean K.',
    lastMessage: 'Merci pour le retour sur SafeRoute237',
    time: 'Lun',
    unread: 0,
    online: true,
    messages: [
      ChatMessage(id: 'm1', kind: MsgKind.text, fromMe: true, time: 'Lun', text: 'Ton projet avance bien !'),
      ChatMessage(id: 'm2', kind: MsgKind.text, fromMe: false, time: 'Lun', text: 'Merci pour le retour sur SafeRoute237'),
    ],
  ),
];

final signalsProvider = Provider<List<Signal>>((ref) => _signals);
final signalOfDayProvider = Provider<Signal>((ref) => _signals.first);
final lessonsProvider = Provider<List<Lesson>>((ref) => _lessons);
final seriesProvider = Provider<List<Series>>((ref) => _series);
final projectsProvider = Provider<List<Project>>((ref) => _projects);
final conversationsProvider = Provider<List<Conversation>>((ref) => _conversations);

Signal? signalById(WidgetRef ref, String id) {
  for (final s in ref.read(signalsProvider)) {
    if (s.id == id) return s;
  }
  return null;
}

Lesson? lessonById(WidgetRef ref, String id) {
  for (final l in ref.read(lessonsProvider)) {
    if (l.id == id) return l;
  }
  return null;
}

Conversation? conversationById(WidgetRef ref, String id) {
  for (final c in ref.read(conversationsProvider)) {
    if (c.id == id) return c;
  }
  return null;
}

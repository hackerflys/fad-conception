import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../state/app_settings.dart';
import '../../features/entry/splash_screen.dart';
import '../../features/entry/onboarding_screen.dart';
import '../../features/entry/interests_screen.dart';
import '../../features/entry/auth_screen.dart';
import '../../features/shell/app_shell.dart';
import '../../features/radar/radar_screen.dart';
import '../../features/radar/signal_detail_screen.dart';
import '../../features/radar/search_screen.dart';
import '../../features/learn/learn_screen.dart';
import '../../features/learn/lesson_detail_screen.dart';
import '../../features/projects/projects_screen.dart';
import '../../features/projects/project_detail_screen.dart';
import '../../features/projects/submit_project_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profile/settings_screen.dart';
import '../../features/messages/messages_screen.dart';
import '../../features/messages/conversation_screen.dart';

final _rootKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/interests', builder: (_, __) => const InterestsScreen()),
      GoRoute(path: '/auth', builder: (_, __) => const AuthScreen()),

      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/radar', builder: (_, __) => const RadarScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/learn', builder: (_, __) => const LearnScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/projects', builder: (_, __) => const ProjectsScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
          ]),
        ],
      ),

      GoRoute(path: '/search', builder: (_, __) => const SearchScreen()),
      GoRoute(path: '/signal/:id', builder: (_, s) => SignalDetailScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/lesson/:id', builder: (_, s) => LessonDetailScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/project/:id', builder: (_, s) => ProjectDetailScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/projects/submit', builder: (_, __) => const SubmitProjectScreen()),
      GoRoute(path: '/messages', builder: (_, __) => const MessagesScreen()),
      GoRoute(path: '/messages/:id', builder: (_, s) => ConversationScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
    ],
    redirect: (context, state) {
      final s = ref.read(settingsProvider);
      final loc = state.matchedLocation;
      if (loc == '/splash') return null; // splash decides
      final entryRoutes = {'/onboarding', '/interests', '/auth'};
      if (!s.onboardingDone && !entryRoutes.contains(loc)) {
        return '/onboarding';
      }
      return null;
    },
  );
});

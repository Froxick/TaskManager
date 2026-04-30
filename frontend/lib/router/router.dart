import 'package:frontend/features/auth/auth_notifier.dart';
import 'package:frontend/features/auth/screen/auth_screen.dart';
import 'package:frontend/features/dashBoard/screen/dashboard_screen.dart';
import 'package:frontend/features/projects/screens/project_screen.dart';
import 'package:frontend/layouts/main_layout.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  refreshListenable: authNotifier,
  redirect: (context, state) {
    print('REDIRECT CALLED: ${authNotifier.value}');
    final isAuthPage = state.matchedLocation == '/auth';

    if (!authNotifier.value && !isAuthPage) {
      return '/auth';
    }

    if (authNotifier.value && isAuthPage) {
      return '/';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/auth',
      pageBuilder: (context, state) => NoTransitionPage(child: AuthScreen()),
    ),
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          NoTransitionPage(child: MainLayout(child: DashboardScreen())),
    ),
    GoRoute(
      path: '/projects',
      pageBuilder: (context, state) =>
          NoTransitionPage(child: MainLayout(child: const ProjectScreen())),
    ),
  ],
);

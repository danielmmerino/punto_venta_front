import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/auth/auth_repository.dart';
import '../../data/auth/auth_state.dart';
import '../../data/subscription/subscription_repository.dart';
import '../../features/_placeholders_/subscription_blocked_page.dart';
import '../../features/auth/ui/login_page.dart';
import '../../features/dashboard/ui/dashboard_page.dart';
import '../../features/_placeholders_/selector_local_page.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _sub;
  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final authStateStream = ref.watch(authStateProvider.stream);
  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(authStateStream),
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(body: SizedBox.shrink()),
      ),
      GoRoute(
        path: '/subscription/blocked',
        builder: (context, state) => const SubscriptionBlockedPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/selector-local',
        builder: (context, state) => const SelectorLocalPage(),
      ),
    ],
    redirect: (context, state) {
      final auth = ref.read(authStateProvider);
      final subRepo = ref.read(subscriptionRepositoryProvider);
      final location = state.subloc;
      if (location == '/subscription/blocked') {
        return null;
      }
      if (auth is Authenticated) {
        if (auth.expiresAt.isBefore(DateTime.now())) {
          return '/login';
        }
        if (!subRepo.isActive) {
          return '/subscription/blocked';
        }
        if (location == '/login') {
          return '/dashboard';
        }
        return null;
      } else if (auth is Authenticating) {
        return null;
      } else {
        if (location == '/login') return null;
        return '/login';
      }
    },
  );
});

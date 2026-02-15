import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/home_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../core/services/service_locator.dart';
import '../core/storage/storage_manager.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  /// THIS is the magic line
  refreshListenable: getIt<SessionManager>(),

  /// Route protection
  redirect: (context, state) {
    final session = getIt<SessionManager>();

    final loggedIn = session.isLoggedIn;
    final goingToOnboarding = state.uri.path == '/onboarding';

    debugPrint("REDIRECT -> loggedIn=$loggedIn  current=${state.uri.path}");

    /// Not logged in → always onboarding
    if (!loggedIn && !goingToOnboarding) {
      return '/onboarding';
    }

    /// Logged in → never onboarding
    if (loggedIn && goingToOnboarding) {
      return '/home';
    }

    return null;
  },

  routes: [
    GoRoute(
      path: '/',
      redirect: (_, __) => '/onboarding',
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);

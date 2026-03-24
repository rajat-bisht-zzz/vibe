import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vibe/core/services/service_locator.dart';
import 'package:vibe/core/storage/storage_manager.dart';
import 'package:vibe/features/auth/presentation/bloc/chat/chat_bloc.dart';
import 'package:vibe/features/auth/presentation/pages/chat_page.dart';
import 'package:vibe/features/auth/presentation/pages/enter_invite_page.dart';
import 'package:vibe/features/auth/presentation/pages/home_page.dart';
import 'package:vibe/features/auth/presentation/pages/onboarding_page.dart';

abstract final class AppRoutes {
  static const root = '/';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const invite = '/invite';
  static const chat = '/chat/:chatId';

  static String chatRoute(String chatId) => '/chat/$chatId';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.root,
  refreshListenable: getIt<SessionManager>(),
  redirect: (context, state) {
    final session = getIt<SessionManager>();
    final path = state.uri.path;

    if (!session.isLoggedIn && path != AppRoutes.onboarding) {
      return AppRoutes.onboarding;
    }

    if (session.isLoggedIn && path == AppRoutes.onboarding) {
      return AppRoutes.home;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.root,
      redirect: (_, __) => AppRoutes.onboarding,
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.invite,
      builder: (context, state) => const EnterInvitePage(),
    ),
    GoRoute(
      path: AppRoutes.chat,
      builder: (context, state) {
        final chatId = state.pathParameters['chatId']!;
        return BlocProvider(
          create: (_) => getIt<ChatBloc>()..add(LoadMessagesEvent(chatId)),
          child: ChatPage(chatId: chatId),
        );
      },
    ),
  ],
);

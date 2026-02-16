import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibe/app/router.dart';
import 'package:vibe/features/auth/presentation/bloc/chat_list/chat_list_bloc.dart';

import 'core/services/service_locator.dart';
import 'core/ui/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();

  runApp(const VibeApp());
}

class VibeApp extends StatelessWidget {
  const VibeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AuthBloc>()..add(CheckAuthEvent()),
        ),
        BlocProvider(
          create: (_) => getIt<ChatListBloc>()..add(LoadChatsEvent()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: appRouter,
      ),
    );
  }
}

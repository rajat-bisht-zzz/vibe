import 'package:flutter/material.dart';
import 'package:vibe/app/router.dart';

import '../core/ui/theme/app_theme.dart';

/// This widget is loaded ONLY after user is authenticated.
/// From here onward, navigation is handled completely by GoRouter.
class LoggedInApp extends StatelessWidget {
  const LoggedInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,

      /// attach GoRouter
      routerConfig: appRouter,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibe/core/storage/storage_manager.dart';
import 'package:vibe/features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/services/service_locator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = getIt<SessionManager>();
    final user = session.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vibe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Welcome, ${user.displayName} 👋',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

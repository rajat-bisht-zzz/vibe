import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vibe/features/auth/presentation/bloc/auth/auth_bloc.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/storage/storage_manager.dart';
import '../bloc/chat_list/chat_list_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = getIt<SessionManager>().currentUser!;

    return BlocProvider(
      create: (_) => getIt<ChatListBloc>()..add(LoadChatsEvent()),
      child: Scaffold(
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
        ),
        body: Column(
          children: [
            /// -------- USER HEADER --------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.grey.shade200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.displayName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Invite: ${user.inviteCode}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),

            /// -------- CHAT LIST --------
            Expanded(
              child: BlocBuilder<ChatListBloc, ChatListState>(
                builder: (context, state) {
                  if (state is ChatListLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ChatListLoaded) {
                    if (state.chats.isEmpty) {
                      return const Center(child: Text("No chats yet"));
                    }

                    return ListView.builder(
                      itemCount: state.chats.length,
                      itemBuilder: (context, index) {
                        final chat = state.chats[index];

                        return ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text("Chat ${chat.id.substring(0, 6)}"),
                          subtitle: const Text("Tap to open conversation"),
                          onTap: () {
                            context.push('/chat/${chat.id}');
                          },
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push('/invite'),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

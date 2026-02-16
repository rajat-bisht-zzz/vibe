import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vibe/core/storage/user_directory.dart';
import 'package:vibe/features/auth/presentation/bloc/auth/auth_bloc.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/storage/storage_manager.dart';
import '../bloc/chat_list/chat_list_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ChatListBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = getIt<ChatListBloc>();
    bloc.add(LoadChatsEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /// called when coming back from another page
    bloc.add(LoadChatsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final user = getIt<SessionManager>().currentUser!;

    return BlocProvider.value(
      value: bloc,
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
                        final myId = getIt<SessionManager>().currentUser!.id;
                        final otherUserId =
                            chat.userA == myId ? chat.userB : chat.userA;
                        final otherUser = UserDirectory.getById(otherUserId);
                        return ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(otherUser?.displayName ?? "Unknown user"),
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

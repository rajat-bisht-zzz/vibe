import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:vibe/core/services/service_locator.dart';
import 'package:vibe/features/auth/presentation/bloc/chat_list/chat_list_bloc.dart';

import '../../../../core/storage/storage_manager.dart';
import '../../domain/usecases/create_chat_usecase.dart';

class EnterInvitePage extends StatefulWidget {
  const EnterInvitePage({super.key});

  @override
  State<EnterInvitePage> createState() => _EnterInvitePageState();
}

class _EnterInvitePageState extends State<EnterInvitePage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Friend"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              "Enter your friend's invite code",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "VIBE-XXXXXX",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final code = controller.text.trim();
                if (code.isEmpty) return;

                final session = getIt<SessionManager>();
                final myId = session.currentUser!.id;

                final createChat = getIt<CreateChatUseCase>();

                final chat = await createChat(myId, code);

                /// IMPORTANT SAFETY CHECK
                if (!mounted) return;

                /// notify chat list
                context.read<ChatListBloc>().add(LoadChatsEvent());

                /// navigate
                context.push('/chat/${chat.id}');
              },
              child: const Text("Start Chat"),
            ),
          ],
        ),
      ),
    );
  }
}

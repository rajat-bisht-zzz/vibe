import 'package:uuid/uuid.dart';
import 'package:vibe/core/services/service_locator.dart';
import 'package:vibe/core/storage/user_directory.dart';
import '../../../../core/storage/storage_manager.dart';
import '../../domain/entities/chat.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDataSource local;

  ChatRepositoryImpl(this.local);

  @override
  Future<Chat> createChat(String myId, String inviteCode) async {
    final friend = UserDirectory.getByInvite(inviteCode);

    /// if friend not found → create simulated friend
    final friendId = friend?.id ?? "friend_${inviteCode.hashCode}";

    final chat = Chat(
      id: const Uuid().v4(),
      userA: myId,
      userB: friendId,
      createdAt: DateTime.now(),
    );

    local.createChat(chat);
    return chat;
  }

  @override
  Future<List<Chat>> getChats() async {
    final myId = getIt<SessionManager>().currentUser!.id;

    final allChats = local.getChats();

    return allChats
        .where((chat) => chat.userA == myId || chat.userB == myId)
        .toList();
  }
}

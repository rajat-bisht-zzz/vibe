import 'package:uuid/uuid.dart';
import 'package:vibe/core/storage/user_directory.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/storage/storage_manager.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_datasource.dart';
import '../datasources/user_local_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDataSource local;
  final UserLocalDataSource userLocal;

  ChatRepositoryImpl(this.local, this.userLocal);

  @override
  Future<Chat> createChat(String myId, String inviteCode) async {
    // 1. Check in-memory cache first
    User? friend = UserDirectory.getByInvite(inviteCode);

    // 2. Fall back to SQLite (covers app-restart scenarios)
    if (friend == null) {
      final allUsers = await userLocal.getAllUsers();
      try {
        friend = allUsers.firstWhere(
          (u) => u.inviteCode.toLowerCase() == inviteCode.toLowerCase(),
        );
      } catch (_) {
        friend = null;
      }
    }

    if (friend == null) {
      // No registered user found — create an anonymous placeholder.
      // displayName will be updated if they register later.
      friend = User(
        id: 'friend_${inviteCode.hashCode}',
        username: 'friend_$inviteCode',
        displayName: inviteCode,
        passwordHash: '',
        inviteCode: inviteCode,
        createdAt: DateTime.now(),
      );
      await userLocal.saveUser(friend);
    }
    // If friend IS found we always use their stored displayName — no override.

    UserDirectory.addUser(friend);

    final chat = Chat(
      id: const Uuid().v4(),
      userA: myId,
      userB: friend.id,
      createdAt: DateTime.now(),
    );

    await local.createChat(chat);
    return chat;
  }

  @override
  Future<List<Chat>> getChats() async {
    final myId = getIt<SessionManager>().currentUser?.id;
    if (myId == null) return const [];

    final allChats = await local.getChats();
    return allChats
        .where((chat) => chat.userA == myId || chat.userB == myId)
        .toList();
  }

  @override
  Future<void> clearAll() => local.clear();
}

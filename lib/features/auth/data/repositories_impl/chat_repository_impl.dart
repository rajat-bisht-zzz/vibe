import 'package:uuid/uuid.dart';
import '../../domain/entities/chat.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDataSource local;

  ChatRepositoryImpl(this.local);

  @override
  Future<Chat> createChat(String myId, String friendCode) async {
    /// for now friendCode acts as friendId
    final chat = Chat(
      id: const Uuid().v4(),
      userA: myId,
      userB: friendCode,
      createdAt: DateTime.now(),
    );

    local.createChat(chat);
    return chat;
  }

  @override
  Future<List<Chat>> getChats() async {
    return local.getChats();
  }
}

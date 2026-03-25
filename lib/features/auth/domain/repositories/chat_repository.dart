import '../entities/chat.dart';

abstract class ChatRepository {
  Future<Chat> createChat(String myId, String inviteCode);
  Future<List<Chat>> getChats();
  Future<void> clearAll();
}

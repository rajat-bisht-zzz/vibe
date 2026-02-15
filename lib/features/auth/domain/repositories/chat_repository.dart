import '../entities/chat.dart';

abstract class ChatRepository {
  Future<Chat> createChat(String myId, String friendCode);
  Future<List<Chat>> getChats();
}

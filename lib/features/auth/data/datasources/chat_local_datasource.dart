import '../../domain/entities/chat.dart';

class ChatLocalDataSource {
  /// pretend database
  static final List<Chat> _chats = [];

  List<Chat> getChats() {
    return _chats;
  }

  void createChat(Chat chat) {
    _chats.add(chat);
  }

  Chat? getChatById(String id) {
    try {
      return _chats.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  static void clear() {
    _chats.clear();
  }
}

import '../../domain/entities/message.dart';

class MessageLocalDataSource {
  /// chatId -> list of messages
  static final Map<String, List<Message>> _messages = {};

  List<Message> getMessages(String chatId) {
    return _messages[chatId] ?? [];
  }

  void sendMessage(Message message) {
    _messages.putIfAbsent(message.chatId, () => []);
    _messages[message.chatId]!.add(message);
  }

  static void clear() {
    _messages.clear();
  }
}

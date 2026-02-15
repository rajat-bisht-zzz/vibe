import '../entities/message.dart';

abstract class MessageRepository {
  Future<List<Message>> getMessages(String chatId);
  Future<void> sendMessage(Message message);
}

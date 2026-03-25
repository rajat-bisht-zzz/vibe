import '../entities/message.dart';

abstract class MessageRepository {
  Future<List<Message>> getMessages(String chatId);
  Stream<List<Message>> watchMessages(String chatId);
  Future<void> sendMessage(Message message);
  Future<void> clearAll();
}

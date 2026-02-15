import '../../domain/entities/message.dart';
import '../../domain/repositories/message_repository.dart';
import '../datasources/message_local_datasource.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageLocalDataSource local;

  MessageRepositoryImpl(this.local);

  @override
  Future<List<Message>> getMessages(String chatId) async {
    return local.getMessages(chatId);
  }

  @override
  Future<void> sendMessage(Message message) async {
    local.sendMessage(message);
  }
}

import '../entities/message.dart';
import '../repositories/message_repository.dart';

class GetMessagesUseCase {
  final MessageRepository repository;

  GetMessagesUseCase(this.repository);

  Future<List<Message>> call(String chatId) {
    return repository.getMessages(chatId);
  }
}

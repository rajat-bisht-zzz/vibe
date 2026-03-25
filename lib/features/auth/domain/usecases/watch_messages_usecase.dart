import '../entities/message.dart';
import '../repositories/message_repository.dart';

class WatchMessagesUseCase {
  final MessageRepository repository;

  WatchMessagesUseCase(this.repository);

  Stream<List<Message>> call(String chatId) {
    return repository.watchMessages(chatId);
  }
}

import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class GetChatsUseCase {
  final ChatRepository repository;

  GetChatsUseCase(this.repository);

  Future<List<Chat>> call() {
    return repository.getChats();
  }
}

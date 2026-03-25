import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class CreateChatUseCase {
  final ChatRepository repository;

  CreateChatUseCase(this.repository);

  Future<Chat> call(String myId, String inviteCode) {
    return repository.createChat(myId, inviteCode);
  }
}

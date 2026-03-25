import '../entities/user.dart';
import '../repositories/user_repository.dart';

class SaveUserToDbUseCase {
  final UserRepository repository;

  SaveUserToDbUseCase(this.repository);

  Future<void> call(User user) {
    return repository.saveUser(user);
  }
}

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SaveUserUseCase {
  final AuthRepository repository;

  SaveUserUseCase(this.repository);

  Future<void> call(User user) {
    return repository.saveUser(user);
  }
}

import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUserByUsernameUseCase {
  final UserRepository repository;

  GetUserByUsernameUseCase(this.repository);

  Future<User?> call(String username) {
    return repository.getUserByUsername(username);
  }
}

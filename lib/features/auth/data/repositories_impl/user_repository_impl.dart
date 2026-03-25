import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl(this.localDataSource);

  @override
  Future<void> saveUser(User user) {
    return localDataSource.saveUser(user);
  }

  @override
  Future<User?> getUserByUsername(String username) {
    return localDataSource.getUserByUsername(username);
  }

  @override
  Future<List<User>> getAllUsers() {
    return localDataSource.getAllUsers();
  }
}

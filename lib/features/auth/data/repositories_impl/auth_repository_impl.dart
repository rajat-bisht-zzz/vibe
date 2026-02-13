import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.localDataSource);

  @override
  Future<void> saveUser(User user) {
    return localDataSource.saveUser(user);
  }

  @override
  Future<User?> getCurrentUser() {
    return localDataSource.getUser();
  }

  @override
  Future<void> clearUser() {
    return localDataSource.clearUser();
  }
}

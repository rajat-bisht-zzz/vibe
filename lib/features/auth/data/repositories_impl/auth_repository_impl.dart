import 'package:vibe/features/auth/data/models/user_model.dart';

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
  Future<User?> getCurrentUser() async {
    try {
      return await localDataSource.getCurrentUser();
    } catch (_) {
      await localDataSource.clearUser();
      return null;
    }
  }

  @override
  Future<void> clearUser() {
    return localDataSource.clearUser();
  }
}

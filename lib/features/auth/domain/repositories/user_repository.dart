import '../entities/user.dart';

abstract class UserRepository {
  Future<void> saveUser(User user);
  Future<User?> getUserByUsername(String username);
  Future<List<User>> getAllUsers();
}

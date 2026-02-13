import '../entities/user.dart';

abstract class AuthRepository {
  /// Save user locally after onboarding
  Future<void> saveUser(User user);

  /// Get the currently logged in user
  Future<User?> getCurrentUser();

  /// Clear session (logout)
  Future<void> clearUser();
}

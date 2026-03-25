import '../repositories/auth_repository.dart';

/// Clears the persisted auth session only.
/// Chat and message history is intentionally kept in SQLite
/// so it survives across logouts and is visible again on next login.
class ClearChatDataUseCase {
  final AuthRepository authRepository;

  ClearChatDataUseCase({
    required this.authRepository,
    // Kept for backwards-compatible DI wiring — no longer used.
    Object? chatRepository,
    Object? messageRepository,
  });

  Future<void> call() async {
    await authRepository.clearUser();
  }
}

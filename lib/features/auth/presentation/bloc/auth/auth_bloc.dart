import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:vibe/core/services/service_locator.dart';
import 'package:vibe/core/storage/storage_manager.dart';
import 'package:vibe/core/storage/user_directory.dart';

import '../../../../../core/utils/password_hasher.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/clear_chat_data_usecase.dart';
import '../../../domain/usecases/get_current_user_usecase.dart';
import '../../../domain/usecases/get_user_by_username_usecase.dart';
import '../../../domain/usecases/save_user_usecase.dart';
import '../../../domain/usecases/save_user_to_db_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

String generateInviteCode() {
  final millis = DateTime.now().millisecondsSinceEpoch;
  return "VIBE-${millis.toString().substring(7, 13)}";
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SaveUserUseCase saveUserUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final GetUserByUsernameUseCase getUserByUsernameUseCase;
  final SaveUserToDbUseCase saveUserToDbUseCase;
  final ClearChatDataUseCase clearChatDataUseCase;

  AuthBloc({
    required this.saveUserUseCase,
    required this.getCurrentUserUseCase,
    required this.getUserByUsernameUseCase,
    required this.saveUserToDbUseCase,
    required this.clearChatDataUseCase,
  }) : super(AuthInitial()) {
    on<CheckAuthEvent>((event, emit) async {
      final user = await getCurrentUserUseCase();

      if (user != null) {
        getIt<SessionManager>().setUser(user);
        UserDirectory.addUser(user);
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    });

    on<RegisterEvent>((event, emit) async {
      final inMemory = UserDirectory.getByUsername(event.username);
      final existing =
          inMemory ?? await getUserByUsernameUseCase(event.username);

      if (existing != null) {
        emit(AuthError("Username already taken"));
        return;
      }

      final newUser = User(
        id: const Uuid().v4(),
        username: event.username,
        displayName: event.displayName,
        passwordHash: hashPassword(event.password),
        inviteCode: generateInviteCode(),
        createdAt: DateTime.now(),
      );

      await saveUserToDbUseCase(newUser);
      UserDirectory.addUser(newUser);
      await saveUserUseCase(newUser);

      getIt<SessionManager>().setUser(newUser);
      emit(Authenticated(newUser));
    });

    on<LoginEvent>((event, emit) async {
      final user = UserDirectory.getByUsername(event.username) ??
          await getUserByUsernameUseCase(event.username);

      if (user == null || user.passwordHash != hashPassword(event.password)) {
        emit(AuthError("Invalid username or password"));
        return;
      }

      UserDirectory.addUser(user);
      await saveUserUseCase(user);
      getIt<SessionManager>().setUser(user);

      emit(Authenticated(user));
    });

    on<LogoutEvent>((event, emit) async {
      getIt<SessionManager>().clear();
      UserDirectory.clear();
      await clearChatDataUseCase();
      emit(Unauthenticated());
    });
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:vibe/core/services/service_locator.dart';
import 'package:vibe/core/storage/storage_manager.dart';
import 'package:vibe/core/storage/user_directory.dart';

import '../../../../../core/utils/password_hasher.dart';
import '../../../data/datasources/chat_local_datasource.dart';
import '../../../data/datasources/message_local_datasource.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/get_current_user_usecase.dart';
import '../../../domain/usecases/save_user_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

String generateInviteCode() {
  final millis = DateTime.now().millisecondsSinceEpoch;
  return "VIBE-${millis.toString().substring(7, 13)}";
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SaveUserUseCase saveUserUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthBloc({
    required this.saveUserUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial()) {
    /// App start check
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

    /// User enters name
  on<RegisterEvent>((event, emit) async {

  final existing = UserDirectory.getByUsername(event.username);

  if (existing != null) {
    emit(AuthError("Username already exists"));
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

  UserDirectory.addUser(newUser);
  await saveUserUseCase(newUser);

  getIt<SessionManager>().setUser(newUser);
  emit(Authenticated(newUser));
});

//login
on<LoginEvent>((event, emit) async {

  final user = UserDirectory.getByUsername(event.username);

  if (user == null ||
      user.passwordHash != hashPassword(event.password)) {
    emit(AuthError("Invalid username or password"));
    return;
  }

  await saveUserUseCase(user);
  getIt<SessionManager>().setUser(user);

  emit(Authenticated(user));
});



    //Logout
    on<LogoutEvent>((event, emit) async {
      getIt<SessionManager>().clear();
ChatLocalDataSource.clear();
  MessageLocalDataSource.clear();
      emit(Unauthenticated());
    });
  }
}

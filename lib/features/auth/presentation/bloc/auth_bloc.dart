import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:vibe/core/services/service_locator.dart';
import 'package:vibe/core/storage/storage_manager.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/save_user_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

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
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    });

    /// User enters name
    on<RegisterUserEvent>((event, emit) async {
      final newUser = User(
        id: const Uuid().v4(),
        displayName: event.name,
        createdAt: DateTime.now(),
      );

      await saveUserUseCase(newUser);

      getIt<SessionManager>().setUser(newUser);

      emit(Authenticated(newUser));
    });

    //Logout
    on<LogoutEvent>((event, emit) async {
      getIt<SessionManager>().clear();

      emit(Unauthenticated());
    });
  }
}

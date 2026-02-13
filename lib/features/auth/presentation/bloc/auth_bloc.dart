import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

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
      emit(Authenticated(newUser));
    });
  }
}

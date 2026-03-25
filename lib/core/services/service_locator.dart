import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:vibe/core/storage/storage_manager.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/chat_local_datasource.dart';
import '../../features/auth/data/datasources/message_local_datasource.dart';
import '../../features/auth/data/datasources/user_local_datasource.dart';
import '../../features/auth/data/repositories_impl/auth_repository_impl.dart';
import '../../features/auth/data/repositories_impl/chat_repository_impl.dart';
import '../../features/auth/data/repositories_impl/message_repository_impl.dart';
import '../../features/auth/data/repositories_impl/user_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/repositories/chat_repository.dart';
import '../../features/auth/domain/repositories/message_repository.dart';
import '../../features/auth/domain/repositories/user_repository.dart';
import '../../features/auth/domain/usecases/clear_chat_data_usecase.dart';
import '../../features/auth/domain/usecases/create_chat_usecase.dart';
import '../../features/auth/domain/usecases/get_all_users_usecase.dart';
import '../../features/auth/domain/usecases/get_chats_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/get_messages_usecase.dart';
import '../../features/auth/domain/usecases/get_user_by_username_usecase.dart';
import '../../features/auth/domain/usecases/save_user_to_db_usecase.dart';
import '../../features/auth/domain/usecases/save_user_usecase.dart';
import '../../features/auth/domain/usecases/send_message_usecase.dart';
import '../../features/auth/domain/usecases/watch_messages_usecase.dart';
import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/auth/presentation/bloc/chat/chat_bloc.dart';
import '../../features/auth/presentation/bloc/chat_list/chat_list_bloc.dart';

final getIt = GetIt.instance;

Future<void> initServiceLocator() async {
  // ── External ──
  getIt.registerLazySingleton(() => const FlutterSecureStorage());
  getIt.registerLazySingleton<SessionManager>(() => SessionManager());

  // ── Data Sources ──
  getIt.registerLazySingleton(() => AuthLocalDataSource(getIt()));
  getIt.registerLazySingleton(() => UserLocalDataSource());
  getIt.registerLazySingleton(() => ChatLocalDataSource());
  getIt.registerLazySingleton(() => MessageLocalDataSource());

  // ── Repositories ──
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthLocalDataSource>()),
  );
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt<UserLocalDataSource>()),
  );
  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
        getIt<ChatLocalDataSource>(), getIt<UserLocalDataSource>()),
  );
  getIt.registerLazySingleton<MessageRepository>(
    () => MessageRepositoryImpl(getIt<MessageLocalDataSource>()),
  );

  // ── Use Cases ──
  getIt.registerLazySingleton(() => SaveUserUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAllUsersUseCase(getIt()));
  getIt.registerLazySingleton(() => GetUserByUsernameUseCase(getIt()));
  getIt.registerLazySingleton(() => SaveUserToDbUseCase(getIt()));
  getIt.registerLazySingleton(() => GetChatsUseCase(getIt()));
  getIt.registerLazySingleton(() => CreateChatUseCase(getIt()));
  getIt.registerLazySingleton(() => SendMessageUseCase(getIt()));
  getIt.registerLazySingleton(() => GetMessagesUseCase(getIt()));
  getIt.registerLazySingleton(() => WatchMessagesUseCase(getIt()));
  getIt.registerLazySingleton(() => ClearChatDataUseCase(
        authRepository: getIt(),
      ));

  // ── Blocs ──
  getIt.registerFactory(
    () => AuthBloc(
      saveUserUseCase: getIt(),
      getCurrentUserUseCase: getIt(),
      getUserByUsernameUseCase: getIt(),
      saveUserToDbUseCase: getIt(),
      clearChatDataUseCase: getIt(),
    ),
  );
  getIt.registerLazySingleton(() => ChatListBloc(getIt()));
  getIt.registerFactory(() => ChatBloc(getIt(), getIt(), getIt()));
}

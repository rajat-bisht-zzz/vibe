import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:vibe/core/storage/storage_manager.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/chat_local_datasource.dart';
import '../../features/auth/data/datasources/message_local_datasource.dart';
import '../../features/auth/data/repositories_impl/auth_repository_impl.dart';
import '../../features/auth/data/repositories_impl/chat_repository_impl.dart';
import '../../features/auth/data/repositories_impl/message_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/repositories/chat_repository.dart';
import '../../features/auth/domain/repositories/message_repository.dart';
import '../../features/auth/domain/usecases/create_chat_usecase.dart';
import '../../features/auth/domain/usecases/get_chats_usecase.dart';
import '../../features/auth/domain/usecases/get_messages_usecase.dart';
import '../../features/auth/domain/usecases/save_user_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/send_message_usecase.dart';
import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/auth/presentation/bloc/chat/chat_bloc.dart';
import '../../features/auth/presentation/bloc/chat_list/chat_list_bloc.dart';

final getIt = GetIt.instance;

Future<void> initServiceLocator() async {
  /// External
  getIt.registerLazySingleton(() => const FlutterSecureStorage());

  /// Data Sources
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(getIt()),
  );

  /// Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );

  /// Bloc
  getIt.registerFactory(
    () => AuthBloc(
      saveUserUseCase: getIt(),
      getCurrentUserUseCase: getIt(),
    ),
  );
  getIt.registerFactory(() => ChatListBloc(getIt()));

  /// Usecases
  getIt.registerLazySingleton(() => SaveUserUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt()));
  getIt.registerLazySingleton(() => GetChatsUseCase(getIt()));

  ///Storage
  getIt.registerLazySingleton<SessionManager>(() => SessionManager());

  /// CHAT
  getIt.registerLazySingleton(() => ChatLocalDataSource());

  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton(
    () => CreateChatUseCase(getIt()),
  );

  //message

  getIt.registerLazySingleton(() => MessageLocalDataSource());

  getIt.registerLazySingleton<MessageRepository>(
    () => MessageRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton(() => SendMessageUseCase(getIt()));
  getIt.registerLazySingleton(() => GetMessagesUseCase(getIt()));
  getIt.registerFactory(() => ChatBloc(getIt(), getIt()));
}

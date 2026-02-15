import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:vibe/core/storage/storage_manager.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/repositories_impl/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/save_user_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

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

  /// Usecases
  getIt.registerLazySingleton(() => SaveUserUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt()));

  ///Storage
  getIt.registerLazySingleton<SessionManager>(() => SessionManager());
}

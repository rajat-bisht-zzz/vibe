import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/repositories_impl/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/save_user_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  /// External
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  /// Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(sl()),
  );

  /// Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  /// Usecases
  sl.registerLazySingleton(() => SaveUserUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
}

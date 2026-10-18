import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_health_app/features/auth/presentation/auth_cubit/auth_cubit.dart';
import 'package:smart_health_app/features/auth/presentation/domain/repos/auth_repo.dart';
import 'package:smart_health_app/features/auth/presentation/domain/repos/auth_repo_impl.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // External
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Repositories
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(firebaseAuth: getIt<FirebaseAuth>()),
  );

  // Cubits / Blocs
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt<AuthRepo>()),
  );
}
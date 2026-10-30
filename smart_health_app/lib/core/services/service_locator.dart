import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_health_app/core/services/auth_session.dart';
import 'package:smart_health_app/features/auth/presentation/auth_cubit/auth_cubit.dart';
import 'package:smart_health_app/features/auth/presentation/domain/repos/auth_repo.dart';
import 'package:smart_health_app/features/auth/presentation/domain/repos/auth_repo_impl.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  if (!getIt.isRegistered<FirebaseAuth>()) {
    getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  }
  if (!getIt.isRegistered<FirebaseFirestore>()) {
    getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  }
  if (!getIt.isRegistered<FirebaseStorage>()) {
    getIt.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
  }

  if (!getIt.isRegistered<AuthSession>()) {
    getIt.registerLazySingleton<AuthSession>(
      () => AuthSession(getIt<FirebaseAuth>(), getIt<FirebaseFirestore>()),
    );
  }

  if (!getIt.isRegistered<AuthRepo>()) {
    getIt.registerLazySingleton<AuthRepo>(
      () => AuthRepoImpl(
        firebaseAuth: getIt<FirebaseAuth>(),
        firestore: getIt<FirebaseFirestore>(),
        firebaseStorage: getIt<FirebaseStorage>(),
      ),
    );
  }

  if (!getIt.isRegistered<AuthCubit>()) {
    getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepo>()));
  }
}
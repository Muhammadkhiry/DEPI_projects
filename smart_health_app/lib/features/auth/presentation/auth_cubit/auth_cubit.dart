import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_health_app/features/auth/presentation/domain/repos/auth_repo.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;

  AuthCubit(this.authRepo) : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    final result = await authRepo.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.errMessage)),
      (_) => emit(AuthSuccess()),
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(AuthLoading());
    final result = await authRepo.signUpWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.errMessage)),
      (_) => emit(AuthSuccess()),
    );
  }

  Future<void> sendPasswordReset({required String email}) async {
    emit(AuthLoading());
    final result = await authRepo.sendPasswordResetEmail(email: email);
    result.fold(
      (failure) => emit(AuthFailure(failure.errMessage)),
      (_) => emit(AuthSuccess()),
    );
  }

  Future<void> completeProfile({
    required String name,
    required String phoneNumber,
    required String bloodType,
    File? imageFile,
  }) async {
    emit(AuthLoading());
    final result = await authRepo.completeProfile(
      name: name,
      phoneNumber: phoneNumber,
      bloodType: bloodType,
      imageFile: imageFile,
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.errMessage)),
      (_) => emit(AuthSuccess()),
    );
  }

  Future<void> fetchUserData() async {
    emit(AuthLoading());
    final result = await authRepo.getUserData();
    result.fold(
      (failure) => emit(AuthFailure(failure.errMessage)),
      (userModel) => emit(UserDataLoaded(userModel)),
    );
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? bloodType,
    bool? isWillingToDonate,
    File? imageFile,
  }) async {
    emit(AuthLoading());
    final result = await authRepo.updateUserProfile(
      name: name,
      phone: phone,
      bloodType: bloodType,
      isWillingToDonate: isWillingToDonate,
      imageFile: imageFile,
    );
    result.fold((failure) => emit(AuthFailure(failure.errMessage)), (_) {
      emit(ProfileUpdatedSuccess());
      fetchUserData();
    });
  }
}

import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:smart_health_app/core/errors/failures.dart';
import 'package:smart_health_app/features/auth/presentation/data/models/user_model.dart';

abstract class AuthRepo {
  Future<Either<Failure, void>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserModel>> getUserData();
  
  Future<Either<Failure, void>> updateUserProfile({
    String? name,
    String? phone,
    String? bloodType,
    bool? isWillingToDonate,
    File? imageFile,
  });
}
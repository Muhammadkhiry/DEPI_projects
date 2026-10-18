import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:smart_health_app/core/errors/failures.dart';

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

  Future<Either<Failure, void>> sendPasswordResetEmail({required String email});

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, void>> completeProfile({
    required String name,
    required String phoneNumber,
    required String bloodType,
    File? imageFile,
  });
}

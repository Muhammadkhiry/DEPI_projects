import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_health_app/core/errors/failures.dart';
import 'package:smart_health_app/features/auth/presentation/data/models/user_model.dart';

import '../../domain/repos/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRepoImpl({required this.firebaseAuth, FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<Failure, void>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure.fromFirebaseAuth(e.code));
    } catch (e) {
      return Left(ServerFailure('An error occurred during login.'));
    }
  }

  @override
  Future<Either<Failure, void>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        await user.updateDisplayName(name);

        // إنشاء الـ User Document في Firestore
        final userModel = UserModel(
          uid: user.uid,
          email: email,
          name: name,
          isProfileCompleted: false,
          createdAt: DateTime.now(),
        );

        await firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toFirestore(), SetOptions(merge: true));
      }

      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure.fromFirebaseAuth(e.code));
    } catch (e) {
      return Left(ServerFailure('An error occurred during sign up.'));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure.fromFirebaseAuth(e.code));
    } catch (e) {
      return Left(ServerFailure('An error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await firebaseAuth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to log out.'));
    }
  }

  @override
  Future<Either<Failure, void>> completeProfile({
    required String name,
    required String phoneNumber,
    required String bloodType,
    File? imageFile,
  }) async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        return Left(ServerFailure('User is not authenticated.'));
      }

      String? imageUrl;

      if (imageFile != null) {
        final storageRef = FirebaseStorage.instance.ref().child(
          'profile_images/${user.uid}.jpg',
        );
        await storageRef.putFile(imageFile);
        imageUrl = await storageRef.getDownloadURL();
      }

      final updateData = {
        'name': name,
        'phoneNumber': phoneNumber,
        'bloodType': bloodType,
        'isProfileCompleted': true,
        'profilePicUrl': ?imageUrl,
      };

      await firestore.collection('users').doc(user.uid).update(updateData);

      await user.updateDisplayName(name);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to complete profile: ${e.toString()}'));
    }
  }
}

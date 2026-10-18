import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smart_health_app/core/errors/failures.dart';
import 'package:smart_health_app/features/auth/presentation/data/models/user_model.dart';

import '../../domain/repos/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;

  AuthRepoImpl({
    required this.firebaseAuth,
    required this.firestore,
    required this.firebaseStorage,
  });

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
  Future<Either<Failure, void>> updateUserProfile({
    String? name,
    String? phone,
    String? bloodType,
    bool? isWillingToDonate,
    File? imageFile,
  }) async {
    try {
      final uid = firebaseAuth.currentUser?.uid;
      if (uid == null) return Left(ServerFailure('User not logged in'));

      Map<String, dynamic> updatedData = {};

      if (name != null) updatedData['name'] = name;
      if (phone != null) updatedData['phoneNumber'] = phone;
      if (bloodType != null) updatedData['bloodType'] = bloodType;
      if (isWillingToDonate != null) {
        updatedData['isWillingToDonate'] = isWillingToDonate;
      }

      if (imageFile != null) {
        final ref = firebaseStorage.ref().child('user_photos/$uid.jpg');
        await ref.putFile(imageFile);
        final imageUrl = await ref.getDownloadURL();
        updatedData['photoUrl'] = imageUrl;
      }

      await firestore.collection('users').doc(uid).update(updatedData);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to update profile: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUserData() async {
    try {
      final uid = firebaseAuth.currentUser?.uid;
      if (uid == null) {
        return Left(ServerFailure('User not logged in'));
      }

      final doc = await firestore.collection('users').doc(uid).get();
      if (!doc.exists || doc.data() == null) {
        return Left(ServerFailure('User data not found'));
      }

      final userModel = UserModel.fromFirestore(
        doc.data()! as DocumentSnapshot<Map<String, dynamic>>,
      );
      return Right(userModel);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch user data: ${e.toString()}'));
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String? name;
  final String? phoneNumber;
  final String? bloodType;
  final String? profilePicUrl;
  final bool isProfileCompleted;
  final DateTime? createdAt;

  // Personal info (task 1.12). Date of birth is stored as "yyyy-MM-dd".
  final String? dateOfBirth;
  final String? gender;

  // Medical info (task 1.12).
  final String? allergies;
  final String? chronicConditions;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? emergencyContactRelationship;

  UserModel({
    required this.uid,
    required this.email,
    this.name,
    this.phoneNumber,
    this.bloodType,
    this.profilePicUrl,
    this.isProfileCompleted = false,
    this.createdAt,
    this.dateOfBirth,
    this.gender,
    this.allergies,
    this.chronicConditions,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.emergencyContactRelationship,
  });

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return UserModel(
      uid: snapshot.id,
      email: data?['email'] as String? ?? '',
      name: data?['name'] as String?,
      phoneNumber: data?['phoneNumber'] as String?,
      bloodType: data?['bloodType'] as String?,
      profilePicUrl: data?['profilePicUrl'] as String?,
      isProfileCompleted: data?['isProfileCompleted'] as bool? ?? false,
      createdAt: (data?['createdAt'] as Timestamp?)?.toDate(),
      dateOfBirth: data?['dateOfBirth'] as String?,
      gender: data?['gender'] as String?,
      allergies: data?['allergies'] as String?,
      chronicConditions: data?['chronicConditions'] as String?,
      emergencyContactName: data?['emergencyContactName'] as String?,
      emergencyContactPhone: data?['emergencyContactPhone'] as String?,
      emergencyContactRelationship:
          data?['emergencyContactRelationship'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'bloodType': bloodType,
      'profilePicUrl': profilePicUrl,
      'isProfileCompleted': isProfileCompleted,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'dateOfBirth': ?dateOfBirth,
      'gender': ?gender,
      'allergies': ?allergies,
      'chronicConditions': ?chronicConditions,
      'emergencyContactName': ?emergencyContactName,
      'emergencyContactPhone': ?emergencyContactPhone,
      'emergencyContactRelationship': ?emergencyContactRelationship,
    };
  }
}

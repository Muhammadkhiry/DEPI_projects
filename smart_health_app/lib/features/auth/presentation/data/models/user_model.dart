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

  UserModel({
    required this.uid,
    required this.email,
    this.name,
    this.phoneNumber,
    this.bloodType,
    this.profilePicUrl,
    this.isProfileCompleted = false,
    this.createdAt,
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
    };
  }
}
/// Single source of truth for Firestore and Storage paths (task 1.5).
///
/// Use these instead of typing collection names by hand, and keep them in sync
/// with `firestore.rules` / `storage.rules`. If you add a new collection, add
/// it here and send Dev1 the rules it needs.
abstract class FirestorePaths {
  // --- Collections -------------------------------------------------------
  static const String users = 'users';

  /// Read-only for the app (filled by the seed script / admin).
  static const String doctors = 'doctors';

  // TODO(Dev3): confirm that appointments and slot locks are top-level
  // collections with a `userId` field. The security rules assume this.
  static const String appointments = 'appointments';
  static const String slots = 'slots';

  // --- Sub-collections of users/{uid} -----------------------------------
  static const String records = 'records';
  static const String donations = 'donations';

  // --- Documents ---------------------------------------------------------
  static String user(String uid) => '$users/$uid';
  static String userRecords(String uid) => '${user(uid)}/$records';
  static String userDonations(String uid) => '${user(uid)}/$donations';
  static String doctor(String doctorId) => '$doctors/$doctorId';
  static String appointment(String appointmentId) =>
      '$appointments/$appointmentId';
}

/// Firebase Storage paths. The Storage rules only allow `users/{uid}/...`
/// for the signed-in owner, so every file must live under [userFolder].
abstract class StoragePaths {
  static String userFolder(String uid) => 'users/$uid';
  static String profilePhoto(String uid) => '${userFolder(uid)}/profile.jpg';

  /// Dev5: put medical-record files under this folder.
  static String recordsFolder(String uid) => '${userFolder(uid)}/records';
}

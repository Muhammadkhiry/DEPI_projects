import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_health_app/features/auth/presentation/data/models/user_model.dart';

/// Whether the signed-in user has finished the "Complete your profile" step.
enum ProfileStatus {
  /// Not loaded yet (or nobody is signed in).
  unknown,
  incomplete,
  completed,
}

/// App-wide auth state (tasks 1.8 and 1.12).
///
/// The router listens to this object, and every other feature reads the
/// signed-in user from here (`getIt<AuthSession>().uid`) instead of calling
/// FirebaseAuth directly. It also keeps a live copy of the user's profile
/// document (`users/{uid}`), so screens can show real data and update by
/// themselves when it changes.
class AuthSession extends ChangeNotifier {
  AuthSession(this._auth, this._firestore) {
    _user = _auth.currentUser;
    _listenToProfile();
    // userChanges() also fires when the user reloads (e.g. email verified).
    _subscription = _auth.userChanges().listen((user) {
      final uidChanged = user?.uid != _user?.uid;
      _user = user;
      if (uidChanged) _listenToProfile();
      notifyListeners();
    });
  }

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  late final StreamSubscription<User?> _subscription;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
  _profileSubscription;

  User? _user;
  UserModel? _profile;
  ProfileStatus _profileStatus = ProfileStatus.unknown;

  bool get isLoggedIn => _user != null;
  String? get uid => _user?.uid;
  String? get email => _user?.email;
  bool get isEmailVerified => _user?.emailVerified ?? false;

  /// Live copy of the user's profile document. Null until it is loaded, or if
  /// the document does not exist yet.
  UserModel? get profile => _profile;
  ProfileStatus get profileStatus => _profileStatus;

  void _listenToProfile() {
    unawaited(_profileSubscription?.cancel());
    _profileSubscription = null;
    _profile = null;
    _profileStatus = ProfileStatus.unknown;

    final uid = _user?.uid;
    if (uid == null) return;

    _profileSubscription = _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen(
          (doc) {
            if (_user == null) return;
            // The document disappears while the account is being deleted. Keep
            // the last known profile until the user is signed out, so the
            // router does not bounce to "Complete profile" in between.
            if (!doc.exists && _profile != null) return;
            _profile = doc.exists ? UserModel.fromFirestore(doc) : null;
            _setProfileStatus(
              (_profile?.isProfileCompleted ?? false)
                  ? ProfileStatus.completed
                  : ProfileStatus.incomplete,
            );
          },
          onError: (Object error) {
            // Fail open: never trap the user on a loading screen if the
            // profile cannot be read (e.g. rules not deployed yet).
            debugPrint('AuthSession: could not read profile: $error');
            if (_user == null) return;
            _setProfileStatus(ProfileStatus.completed);
          },
        );
  }

  void _setProfileStatus(ProfileStatus status) {
    _profileStatus = status;
    notifyListeners();
  }

  /// Reloads the user from Firebase and returns true if the email is now
  /// verified. Call this from the "I've verified my email" button.
  Future<bool> refreshEmailVerified() async {
    try {
      await _auth.currentUser?.reload();
    } on FirebaseAuthException {
      return false;
    }
    _user = _auth.currentUser;
    notifyListeners();
    return isEmailVerified;
  }

  /// Sends the verification email again.
  /// Returns null on success, or a message that can be shown to the user.
  Future<String?> sendVerificationEmail() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        return 'Too many requests. Please wait a bit and try again.';
      }
      return e.message ?? 'Could not send the email.';
    }
  }

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    unawaited(_profileSubscription?.cancel());
    super.dispose();
  }
}

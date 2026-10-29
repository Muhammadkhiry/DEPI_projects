import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// App-wide auth state (task 1.8).
///
/// The router listens to this object, and every other feature reads the
/// signed-in user from here (`getIt<AuthSession>().uid`) instead of calling
/// FirebaseAuth directly.
class AuthSession extends ChangeNotifier {
  AuthSession(this._auth) {
    _user = _auth.currentUser;
    // userChanges() also fires when the user reloads (e.g. email verified).
    _subscription = _auth.userChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  final FirebaseAuth _auth;
  late final StreamSubscription<User?> _subscription;
  User? _user;

  bool get isLoggedIn => _user != null;
  String? get uid => _user?.uid;
  String? get email => _user?.email;
  bool get isEmailVerified => _user?.emailVerified ?? false;

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

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}

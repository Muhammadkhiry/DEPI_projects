import 'package:flutter_test/flutter_test.dart';
import 'package:smart_health_app/core/errors/failures.dart';

void main() {
  group('ServerFailure.fromFirebaseAuth', () {
    final expectedMessages = <String, String>{
      'user-not-found': 'No user found with this email.',
      'wrong-password': 'Wrong password. Please try again.',
      'invalid-credential': 'Incorrect email or password.',
      'email-already-in-use': 'This email is already registered.',
      'invalid-email': 'The email address is invalid.',
      'weak-password': 'The password is too weak.',
      'too-many-requests': 'Too many attempts. Please try again later.',
      'network-request-failed': 'No internet connection. Please try again.',
      'user-disabled': 'This account has been disabled.',
      'requires-recent-login': 'Please sign in again and retry.',
    };

    expectedMessages.forEach((code, message) {
      test('maps "$code" to a readable message', () {
        expect(ServerFailure.fromFirebaseAuth(code).errMessage, message);
      });
    });

    test('falls back to a generic message for unknown codes', () {
      expect(
        ServerFailure.fromFirebaseAuth('something-new').errMessage,
        'An unexpected authentication error occurred.',
      );
    });
  });
}

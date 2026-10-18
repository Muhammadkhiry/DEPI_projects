abstract class Failure {
  final String errMessage;
  const Failure(this.errMessage);
}

class ServerFailure extends Failure {
  ServerFailure(super.errMessage);

  factory ServerFailure.fromFirebaseAuth(String code) {
    switch (code) {
      case 'user-not-found':
        return ServerFailure('No user found with this email.');
      case 'wrong-password':
        return ServerFailure('Wrong password. Please try again.');
      case 'email-already-in-use':
        return ServerFailure('This email is already registered.');
      case 'invalid-email':
        return ServerFailure('The email address is invalid.');
      case 'weak-password':
        return ServerFailure('The password is too weak.');
      default:
        return ServerFailure('An unexpected authentication error occurred.');
    }
  }
}
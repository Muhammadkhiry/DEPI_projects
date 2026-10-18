import 'package:smart_health_app/features/auth/presentation/data/models/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String errMessage;
  AuthFailure(this.errMessage);
}

// في auth_state.dart
class UserDataLoaded extends AuthState {
  final UserModel userModel;
  UserDataLoaded(this.userModel);
}

class ProfileUpdatedSuccess extends AuthState {}
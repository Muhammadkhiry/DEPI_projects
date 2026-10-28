import '../../models/user_model.dart';

abstract class UserStates {}

class UserInitialState extends UserStates {}

class UserLoadingState extends UserStates {}

class UserSuccessState extends UserStates {
  final UserModel user;
  UserSuccessState({required this.user});
}

class UserFailureState extends UserStates {
  final String errorMessage;
  UserFailureState({required this.errorMessage});
}
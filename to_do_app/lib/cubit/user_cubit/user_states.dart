abstract class UserStates {}

class UserInitialState extends UserStates {}

class UserLoggedOutState extends UserStates {}

class UserSavedState extends UserStates {
  final String userName;
  UserSavedState(this.userName);
}

class UserErrorState extends UserStates {
  final String message;
  UserErrorState(this.message);
}
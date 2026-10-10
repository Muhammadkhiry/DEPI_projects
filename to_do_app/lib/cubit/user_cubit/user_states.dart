// user_states.dart
abstract class UserStates {}

class UserInitialState extends UserStates {}

class UserSavedState extends UserStates {
  final String userName;
  UserSavedState(this.userName);
}

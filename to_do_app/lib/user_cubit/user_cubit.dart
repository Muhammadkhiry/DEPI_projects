import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/cubits/user_cubit/user_states.dart';

class UserCubit extends Cubit<UserStates> {
  UserCubit() : super(UserInitialState());

  String _userName = '';

  String get userName => _userName;

  void saveUserName(String name) {
    if (name.trim().isNotEmpty) {
      _userName = name.trim();
      emit(UserSavedState(_userName));
    }
  }
}

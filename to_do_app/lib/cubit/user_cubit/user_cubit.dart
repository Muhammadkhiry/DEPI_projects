import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/cubit/user_cubit/user_states.dart';
import 'package:to_do_app/models/user_model.dart';

class UserCubit extends Cubit<UserStates> {
  UserCubit() : super(UserInitialState());

  Box<UserModel>? _userBox;
  UserModel? _currentUser;

  String get userName {
    if (_currentUser != null) return _currentUser!.name;

    if (Hive.isBoxOpen('userBox')) {
      final box = Hive.box<UserModel>('userBox');
      if (box.isNotEmpty) {
        _currentUser = box.getAt(0);
        return _currentUser?.name ?? '';
      }
    }
    return '';
  }

  Future<void> initUser() async {
    _userBox = Hive.box<UserModel>('userBox');

    if (_userBox!.isNotEmpty) {
      _currentUser = _userBox!.getAt(0);
      emit(UserSavedState(_currentUser!.name));
    } else {
      emit(UserLoggedOutState());
    }
  }

  void loginOrRegister(String name, String password) {
    final trimmedName = name.trim();
    final trimmedPassword = password.trim();

    if (trimmedName.isEmpty || trimmedPassword.isEmpty) {
      emit(UserErrorState("Please enter both Name and Password"));
      return;
    }

    final box = Hive.box<UserModel>('userBox');

    final existingUserIndex = box.values.toList().indexWhere(
      (user) => user.name.toLowerCase() == trimmedName.toLowerCase(),
    );

    if (existingUserIndex != -1) {
      final storedUser = box.getAt(existingUserIndex)!;

      if (storedUser.password == trimmedPassword) {
        _currentUser = storedUser;
        emit(UserSavedState(_currentUser!.name));
      } else {
        emit(UserErrorState("Account already exists with wrong password!"));
      }
    } else {
      final newUser = UserModel(name: trimmedName, password: trimmedPassword);
      box.add(newUser);
      _currentUser = newUser;
      emit(UserSavedState(_currentUser!.name));
    }
  }

  void updateUserProfile({
    required String newName,
    required String newPassword,
  }) {
    if (_currentUser != null) {
      if (newName.trim().isNotEmpty) _currentUser!.name = newName.trim();
      if (newPassword.trim().isNotEmpty) {
        _currentUser!.password = newPassword.trim();
      }
      _currentUser!.save();
      emit(UserSavedState(_currentUser!.name));
    }
  }

  void logout() async {
    _currentUser = null;
    if (_userBox != null) {
      await _userBox!.clear();
    }
    emit(UserLoggedOutState());
  }
}

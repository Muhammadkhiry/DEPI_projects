import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/user_model.dart';
import 'user_states.dart';

class UserCubit extends Cubit<UserStates> {
  UserCubit() : super(UserInitialState());

  static const String userBoxName = 'user_box';

  String userName = '';

  // جلب أو تهيئة بيانات المستخدم
  Future<void> getUserProfile() async {
    emit(UserLoadingState());
    try {
      var box = await Hive.openBox<UserModel>(userBoxName);
      final user = box.get('current_user');
      if (user != null) {
        userName = user.name;
        emit(UserSuccessState(user: user));
      } else {
        emit(UserInitialState());
      }
    } catch (e) {
      emit(UserFailureState(errorMessage: e.toString()));
    }
  }

  // حفظ/تحديث اسم المستخدم
  Future<void> saveUserProfile(String name) async {
    emit(UserLoadingState());
    try {
      var box = await Hive.openBox<UserModel>(userBoxName);
      final user = UserModel(name: name);
      await box.put('current_user', user);
      userName = name;
      emit(UserSuccessState(user: user));
    } catch (e) {
      emit(UserFailureState(errorMessage: e.toString()));
    }
  }

  // تسجيل الخروج / مسح الحساب المحلي
  // في user_cubit.dart
Future<void> logout() async {
  try {
    var box = await Hive.openBox<UserModel>(userBoxName);
    await box.clear(); // Clear cached user
    userName = '';
    emit(UserInitialState());
  } catch (e) {
    emit(UserFailureState(errorMessage: e.toString()));
  }
}

  
}
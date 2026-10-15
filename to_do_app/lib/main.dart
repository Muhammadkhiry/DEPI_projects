import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/cubit/task_cubit/tasks_cubit.dart';
import 'package:to_do_app/cubit/user_cubit/user_cubit.dart';
import 'package:to_do_app/cubit/user_cubit/user_states.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/models/user_model.dart';
import 'package:to_do_app/views/home_view.dart';
import 'package:to_do_app/views/log_in_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(UserModelAdapter());

  await Hive.openBox<TaskModel>('tasksBox');
  await Hive.openBox<UserModel>('userBox');

  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TasksCubit()..initHive()),
        BlocProvider(create: (context) => UserCubit()..initUser()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<UserCubit, UserStates>(
          builder: (context, state) {
            if (state is UserSavedState) {
              return HomeView();
            } else {
              return LoginView(); 
            }
          },
        ),
      ),
    );
  }
}

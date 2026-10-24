import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'cubit/task_cubit/tasks_cubit.dart';
import 'cubit/user_cubit/user_cubit.dart';
import 'models/task_model.dart';
import 'models/user_model.dart';
import 'views/home_view.dart';
import 'views/log_in_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(UserModelAdapter());

  // Open Hive Boxes
  await Hive.openBox<TaskModel>('tasks_box');
  var userBox = await Hive.openBox<UserModel>(UserCubit.userBoxName);

  bool isLoggedIn = userBox.get('current_user') != null;

  runApp(ToDoApp(isLoggedIn: isLoggedIn));
}

class ToDoApp extends StatelessWidget {
  final bool isLoggedIn;
  const ToDoApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserCubit()..getUserProfile(),
        ),
        BlocProvider(
          create: (context) => TasksCubit()..getTasks(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'To Do App',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xff00A896),
        ),
        home: isLoggedIn ? const HomeView() : const LogInView(),
      ),
    );
  }
}
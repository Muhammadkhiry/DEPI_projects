import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/cubits/task_cubit/tasks_cubit.dart';
import 'package:to_do_app/cubits/user_cubit/user_cubit.dart';
import 'package:to_do_app/cubits/user_cubit/user_states.dart';
import 'package:to_do_app/views/home_view.dart';
import 'package:to_do_app/views/log_in_view.dart';

void main() {
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TasksCubit()..displayTasks()),
        BlocProvider(create: (context) => UserCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<UserCubit, UserStates>(
          builder: (context, state) {
            if (state is UserInitialState)
              return LoginView();
            else 
              return HomeView();
          },
        ),
      ),
    );
  }
}

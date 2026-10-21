import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/task_cubit/tasks_cubit.dart';
import '../cubit/task_cubit/tasks_states.dart';
import '../widgets/task_builder.dart';

class CompletedTasksView extends StatelessWidget {
  const CompletedTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Completed Tasks"),
        backgroundColor: const Color(0xff03A0A7),
      ),
      body: BlocBuilder<TasksCubit, TasksStates>(
        builder: (context, state) {
          final completedTasks = context.watch<TasksCubit>().completedTasks;

          if (completedTasks.isEmpty) {
            return const Center(
              child: Text(
                "No completed tasks yet!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return TaskBuilder(tasks: completedTasks);
        },
      ),
    );
  }
}
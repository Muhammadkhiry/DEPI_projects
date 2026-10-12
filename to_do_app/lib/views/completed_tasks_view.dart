import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/cubit/task_cubit/tasks_cubit.dart';
import 'package:to_do_app/cubit/task_cubit/tasks_states.dart';
import 'package:to_do_app/widgets/no_tasks_widget.dart';
import 'package:to_do_app/widgets/task_builder.dart';

class CompletedTasksView extends StatelessWidget {
  const CompletedTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Completed Tasks"),
        backgroundColor: const Color(0xFF00B4D8),
      ),
      body: BlocBuilder<TasksCubit, TasksStates>(
        builder: (context, state) {
          final completed = BlocProvider.of<TasksCubit>(context).completedTasks;
          if (completed.isEmpty) {
            return const NoTasksWidget();
          }
          return ListView.builder(
            itemCount: completed.length,
            itemBuilder: (context, index) {
              return TaskBuilder(taskModel: completed[index]);
            },
          );
        },
      ),
    );
  }
}
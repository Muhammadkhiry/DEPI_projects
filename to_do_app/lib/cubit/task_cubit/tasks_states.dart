import 'package:to_do_app/models/task_model.dart';

class TasksStates {}

class TasksInitial extends TasksStates {}

class TasksLoading extends TasksStates {}

class TasksSuccess extends TasksStates {
  final List<TaskModel> tasks;
  final List<TaskModel> completedTasks;

  TasksSuccess({required this.tasks, required this.completedTasks});
}

class CompletedTask {}

class TasksError extends TasksStates {
  final String message;

  TasksError({required this.message});
}

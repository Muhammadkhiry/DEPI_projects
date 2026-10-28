import '../../models/task_model.dart';

abstract class TasksStates {}

class TasksInitialState extends TasksStates {}

class TasksLoadingState extends TasksStates {}

class TasksSuccessState extends TasksStates {
  final List<TaskModel> tasks;
  TasksSuccessState({required this.tasks});
}

class TasksFailureState extends TasksStates {
  final String errorMessage;
  TasksFailureState({required this.errorMessage});
}
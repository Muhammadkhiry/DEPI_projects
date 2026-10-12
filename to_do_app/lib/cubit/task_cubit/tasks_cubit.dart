import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/cubit/task_cubit/tasks_states.dart';
import 'package:to_do_app/models/task_model.dart';

class TasksCubit extends Cubit<TasksStates> {
  TasksCubit() : super(TasksInitial());

  List<TaskModel> tasks = [];
  List<TaskModel> completedTasks = [];
  Box<TaskModel>? _tasksBox;

  Future<void> initHive() async {
    _tasksBox = Hive.box<TaskModel>('tasksBox');
    loadTasks();
  }

  void loadTasks() {
    emit(TasksLoading());
    if (_tasksBox != null) {
      final allStored = _tasksBox!.values.toList();
      tasks = allStored.where((t) => !t.isDone).toList();
      completedTasks = allStored.where((t) => t.isDone).toList();
    }
    _emitSuccess();
  }

  void displayTasks() {
    loadTasks();
  }

  void addTask({required String title, required String date}) {
    if (title.trim().isNotEmpty && date.trim().isNotEmpty) {
      String generatedId = DateTime.now().millisecondsSinceEpoch.toString();
      TaskModel newTask = TaskModel(id: generatedId, title: title, date: date);

      tasks.add(newTask);
      _tasksBox?.put(generatedId, newTask);
      _emitSuccess();
    } else {
      emit(TasksError(message: "Title or Date cannot be empty"));
    }
  }

  void toggleTaskStatus(TaskModel task) {
    task.isDone = !task.isDone;
    task.save(); // Updates Hive directly

    if (task.isDone) {
      tasks.removeWhere((t) => t.id == task.id);
      completedTasks.add(task);
    } else {
      completedTasks.removeWhere((t) => t.id == task.id);
      tasks.add(task);
    }
    _emitSuccess();
  }

  void deleteTask(String id) {
    tasks.removeWhere((task) => task.id == id);
    completedTasks.removeWhere((task) => task.id == id);
    _tasksBox?.delete(id);

    _emitSuccess();
  }

  void _emitSuccess() {
    emit(
      TasksSuccess(
        tasks: List.from(tasks),
        completedTasks: List.from(completedTasks),
      ),
    );
  }
}
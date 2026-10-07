import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/cubits/task_cubit/tasks_states.dart';
import 'package:to_do_app/models/task_model.dart';

class TasksCubit extends Cubit<TasksStates> {
  TasksCubit() : super(TasksInitial());

  List<TaskModel> tasks = [];
  List<TaskModel> completedTasks = [];
  int _idCounter = 0;
  
  void displayTasks() {
    emit(TasksLoading());
    emit(
      TasksSuccess(
        completedTasks: List.from(completedTasks),
        tasks: List.from(tasks),
      ),
    );
  }

  void addTask({required String title, required String date}) {
    if (title.trim().isNotEmpty && date.trim().isNotEmpty) {
      String generatedId = "T${_idCounter.toString().padLeft(3, '0')}";
      _idCounter++;

      TaskModel newTask = TaskModel(id: generatedId, title: title, date: date);

      tasks.add(newTask);
      emit(
        TasksSuccess(
          completedTasks: List.from(completedTasks),
          tasks: List.from(tasks),
        ),
      );
    } else {
      emit(TasksError(message: "Title or Date cannot be empty"));
    }
  }

  void completeTask(TaskModel task) {
    task.isDone = true;
    tasks.remove(task);
    completedTasks.add(task);
    emit(
      TasksSuccess(
        tasks: List.from(tasks),
        completedTasks: List.from(completedTasks),
      ),
    );
  }

  void toggleTaskStatus(TaskModel task) {
    task.isDone = !task.isDone;

    if (task.isDone) {
      tasks.remove(task);
      completedTasks.add(task);
    } else {
      completedTasks.remove(task);
      tasks.add(task);
    }

    emit(
      TasksSuccess(
        completedTasks: List.from(completedTasks),
        tasks: List.from(tasks),
      ),
    );
  }

  void deleteTask(String id) {
    tasks.removeWhere((task) => task.id == id);
    completedTasks.removeWhere((task) => task.id == id);

    emit(
      TasksSuccess(
        completedTasks: List.from(completedTasks),
        tasks: List.from(tasks),
      ),
    );
  }
}

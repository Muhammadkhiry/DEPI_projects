import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/task_model.dart';
import 'tasks_states.dart';

class TasksCubit extends Cubit<TasksStates> {
  TasksCubit() : super(TasksInitialState());

  static const String tasksBoxName = 'tasks_box';
  List<TaskModel> tasks = [];

  // جلب كافة المهام
  void getTasks() async {
    try {
      var box = Hive.box<TaskModel>(tasksBoxName);
      tasks = box.values.toList();
      emit(TasksSuccessState(tasks: tasks));
    } catch (e) {
      emit(TasksFailureState(errorMessage: e.toString()));
    }
  }

  // Getter للمهام المكتملة
  List<TaskModel> get completedTasks {
    return tasks.where((task) => task.isCompleted).toList();
  }

  // إضافة مهمة جديدة
  Future<void> addTask(TaskModel task) async {
    emit(TasksLoadingState());
    try {
      var box = Hive.box<TaskModel>(tasksBoxName);
      await box.add(task);
      getTasks();
    } catch (e) {
      emit(TasksFailureState(errorMessage: e.toString()));
    }
  }

  // تغيير حالة المهمة (مكتملة / غير مكتملة)
  Future<void> toggleTaskStatus(TaskModel task) async {
    try {
      task.isCompleted = !task.isCompleted;
      await task.save(); // حفظ التعديل في Hive
      getTasks();
    } catch (e) {
      emit(TasksFailureState(errorMessage: e.toString()));
    }
  }

  // حذف مهمة
  Future<void> deleteTask(TaskModel task) async {
    try {
      await task.delete(); // حذف من Hive
      getTasks();
    } catch (e) {
      emit(TasksFailureState(errorMessage: e.toString()));
    }
  }
}
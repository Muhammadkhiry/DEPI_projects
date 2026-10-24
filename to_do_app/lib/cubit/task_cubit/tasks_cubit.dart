import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
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

  String get _today => DateFormat('yyyy-MM-dd').format(DateTime.now());

  // مهام النهارده
  List<TaskModel> get todayTasks =>
      tasks.where((task) => task.date == _today).toList();

  // مهام النهارده غير المكتملة
  List<TaskModel> get todayPending =>
      todayTasks.where((task) => !task.isCompleted).toList();

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

  // تعديل مهمة
  Future<void> editTask(TaskModel task, String title, String date) async {
    try {
      task.title = title;
      task.date = date;
      await task.save();
      getTasks();
    } catch (e) {
      emit(TasksFailureState(errorMessage: e.toString()));
    }
  }

  // مسح كل المهام (عند تسجيل الخروج)
  Future<void> clearTasks() async {
    try {
      await Hive.box<TaskModel>(tasksBoxName).clear();
      getTasks();
    } catch (e) {
      emit(TasksFailureState(errorMessage: e.toString()));
    }
  }
}

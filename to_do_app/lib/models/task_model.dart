class TaskModel {
  final String title, id, date;

  bool isDone;

  TaskModel({
    required this.title,
    required this.date,
    required this.id,
    this.isDone = false,
  });
}

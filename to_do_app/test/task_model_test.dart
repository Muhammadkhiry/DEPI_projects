import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_app/models/task_model.dart';

void main() {
  group('TaskModel', () {
    test('is not completed by default', () {
      final task = TaskModel(id: '1', title: 'Study', date: '2026-10-25');
      expect(task.isCompleted, false);
    });

    test('title and date can be edited', () {
      final task = TaskModel(id: '1', title: 'Study', date: '2026-10-25');
      task.title = 'Study Flutter';
      task.date = '2026-10-26';
      expect(task.title, 'Study Flutter');
      expect(task.date, '2026-10-26');
    });

    test('completion can be toggled', () {
      final task = TaskModel(id: '1', title: 'Study', date: '2026-10-25');
      task.isCompleted = !task.isCompleted;
      expect(task.isCompleted, true);
    });
  });
}

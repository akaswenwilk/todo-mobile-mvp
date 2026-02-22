import 'package:flutter_test/flutter_test.dart';
import 'package:todo_mobile_mvp/features/tasks/domain/entities/task.dart';
import 'package:todo_mobile_mvp/features/tasks/domain/policies/task_visibility_policy.dart';

void main() {
  group('TaskVisibilityPolicy.activeOnly', () {
    test('filters out completed tasks and keeps sort order', () {
      final tasks = [
        Task(
          id: '2',
          title: 'Completed',
          sortOrder: 1,
          isCompleted: true,
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 1),
          completedAt: DateTime.utc(2026, 1, 1),
        ),
        Task(
          id: '3',
          title: 'Later',
          sortOrder: 2,
          isCompleted: false,
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 1),
        ),
        Task(
          id: '1',
          title: 'First',
          sortOrder: 0,
          isCompleted: false,
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 1),
        ),
      ];

      final active = TaskVisibilityPolicy.activeOnly(tasks);

      expect(active.map((task) => task.id), ['1', '3']);
    });
  });
}

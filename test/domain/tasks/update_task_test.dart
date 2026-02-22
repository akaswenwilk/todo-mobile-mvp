import 'package:flutter_test/flutter_test.dart';
import 'package:todo_mobile_mvp/features/tasks/domain/entities/task.dart';
import 'package:todo_mobile_mvp/features/tasks/domain/errors/task_validation_exception.dart';
import 'package:todo_mobile_mvp/features/tasks/domain/usecases/update_task.dart';

import 'fake_task_repository.dart';

void main() {
  group('UpdateTask', () {
    test('updates with normalized title', () async {
      final repo = FakeTaskRepository(
        tasks: [
          Task(
            id: 't1',
            title: 'Old',
            sortOrder: 0,
            isCompleted: false,
            createdAt: DateTime.utc(2026, 1, 1),
            updatedAt: DateTime.utc(2026, 1, 1),
          ),
        ],
      );
      final useCase = UpdateTask(repo);

      await useCase(taskId: 't1', rawTitle: '  New title  ');

      expect(repo.lastUpdatedTaskId, 't1');
      expect(repo.lastUpdatedTitle, 'New title');
    });

    test('rejects empty task id', () async {
      final repo = FakeTaskRepository();
      final useCase = UpdateTask(repo);

      expect(
        () => useCase(taskId: '  ', rawTitle: 'Good'),
        throwsA(isA<TaskValidationException>()),
      );
    });

    test('rejects invalid title', () async {
      final repo = FakeTaskRepository();
      final useCase = UpdateTask(repo);

      expect(
        () => useCase(taskId: 't1', rawTitle: '  '),
        throwsA(isA<TaskValidationException>()),
      );
    });
  });
}

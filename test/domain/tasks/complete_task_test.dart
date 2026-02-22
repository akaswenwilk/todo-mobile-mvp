import 'package:flutter_test/flutter_test.dart';
import 'package:todo_mobile_mvp/features/tasks/domain/errors/task_validation_exception.dart';
import 'package:todo_mobile_mvp/features/tasks/domain/usecases/complete_task.dart';

import 'fake_task_repository.dart';

void main() {
  group('CompleteTask', () {
    test('passes valid id to repository', () async {
      final repo = FakeTaskRepository();
      final useCase = CompleteTask(repo);

      await useCase('task-1');

      expect(repo.lastCompletedTaskId, 'task-1');
    });

    test('rejects empty id', () async {
      final repo = FakeTaskRepository();
      final useCase = CompleteTask(repo);

      expect(() => useCase('  '), throwsA(isA<TaskValidationException>()));
    });
  });
}

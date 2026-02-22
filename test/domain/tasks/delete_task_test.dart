import 'package:flutter_test/flutter_test.dart';
import 'package:todo_mobile_mvp/features/tasks/domain/errors/task_validation_exception.dart';
import 'package:todo_mobile_mvp/features/tasks/domain/usecases/delete_task.dart';

import 'fake_task_repository.dart';

void main() {
  group('DeleteTask', () {
    test('passes valid id to repository', () async {
      final repo = FakeTaskRepository();
      final useCase = DeleteTask(repo);

      await useCase('task-1');

      expect(repo.lastDeletedTaskId, 'task-1');
    });

    test('rejects empty id', () async {
      final repo = FakeTaskRepository();
      final useCase = DeleteTask(repo);

      expect(() => useCase('   '), throwsA(isA<TaskValidationException>()));
    });
  });
}

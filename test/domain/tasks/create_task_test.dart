import 'package:flutter_test/flutter_test.dart';
import 'package:todo_mobile_mvp/features/tasks/domain/errors/task_validation_exception.dart';
import 'package:todo_mobile_mvp/features/tasks/domain/usecases/create_task.dart';

import 'fake_task_repository.dart';

void main() {
  group('CreateTask', () {
    test('creates task with normalized title', () async {
      final repo = FakeTaskRepository();
      final useCase = CreateTask(repo);

      await useCase('  First task  ');

      expect(repo.lastCreatedTitle, 'First task');
    });

    test('rejects empty/whitespace title', () async {
      final repo = FakeTaskRepository();
      final useCase = CreateTask(repo);

      expect(() => useCase('   '), throwsA(isA<TaskValidationException>()));
    });
  });
}

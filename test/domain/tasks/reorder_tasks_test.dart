import 'package:flutter_test/flutter_test.dart';
import 'package:todo_mobile_mvp/features/tasks/domain/errors/task_validation_exception.dart';
import 'package:todo_mobile_mvp/features/tasks/domain/usecases/reorder_tasks.dart';

import 'fake_task_repository.dart';

void main() {
  group('ReorderTasks', () {
    test('passes normalized ids to repository', () async {
      final repo = FakeTaskRepository();
      final useCase = ReorderTasks(repo);

      await useCase(['  t1 ', 't2']);

      expect(repo.lastReorderIds, ['t1', 't2']);
    });

    test('rejects empty ids', () async {
      final repo = FakeTaskRepository();
      final useCase = ReorderTasks(repo);

      expect(
        () => useCase(['t1', '  ']),
        throwsA(isA<TaskValidationException>()),
      );
    });

    test('rejects duplicate ids', () async {
      final repo = FakeTaskRepository();
      final useCase = ReorderTasks(repo);

      expect(
        () => useCase(['t1', 't1']),
        throwsA(isA<TaskValidationException>()),
      );
    });
  });
}

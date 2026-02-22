import 'package:flutter_test/flutter_test.dart';
import 'package:todo_mobile_mvp/core/time/clock.dart';
import 'package:todo_mobile_mvp/core/utils/ids.dart';
import 'package:todo_mobile_mvp/features/tasks/data/datasources/in_memory_task_store.dart';
import 'package:todo_mobile_mvp/features/tasks/data/repositories/task_repository_local.dart';

class FakeClock implements Clock {
  FakeClock(this._now);

  DateTime _now;

  @override
  DateTime now() => _now;

  void setNow(DateTime value) => _now = value;
}

class FakeIdGenerator implements IdGenerator {
  FakeIdGenerator(this._ids);

  final List<String> _ids;
  int _index = 0;

  @override
  String next() {
    if (_index >= _ids.length) {
      throw StateError('No more fake ids.');
    }

    return _ids[_index++];
  }
}

void main() {
  group('TaskRepositoryLocal contract', () {
    late InMemoryTaskStore store;
    late FakeClock clock;
    late FakeIdGenerator ids;
    late TaskRepositoryLocal repository;

    setUp(() {
      store = InMemoryTaskStore();
      clock = FakeClock(DateTime.utc(2026, 2, 22, 12, 0, 0));
      ids = FakeIdGenerator(['t1', 't2', 't3', 't4']);
      repository = TaskRepositoryLocal(store, clock: clock, idGenerator: ids);
    });

    test('create + reload returns active tasks in sort order', () async {
      await repository.createTask('First');
      await repository.createTask('Second');

      final reloaded = TaskRepositoryLocal(
        store,
        clock: clock,
        idGenerator: ids,
      );
      final tasks = await reloaded.getActiveTasks();

      expect(tasks.map((t) => t.id), ['t1', 't2']);
      expect(tasks.map((t) => t.sortOrder), [0, 1]);
    });

    test('update persists title changes across reload', () async {
      await repository.createTask('Original');
      clock.setNow(DateTime.utc(2026, 2, 22, 12, 5, 0));

      final updated = await repository.updateTask(
        taskId: 't1',
        title: 'Updated',
      );
      expect(updated.title, 'Updated');
      expect(updated.updatedAt, DateTime.utc(2026, 2, 22, 12, 5, 0));

      final reloaded = TaskRepositoryLocal(
        store,
        clock: clock,
        idGenerator: ids,
      );
      final tasks = await reloaded.getActiveTasks();
      expect(tasks.single.title, 'Updated');
    });

    test('complete hides task from active list and persists', () async {
      await repository.createTask('Task A');
      await repository.createTask('Task B');
      clock.setNow(DateTime.utc(2026, 2, 22, 12, 10, 0));

      await repository.completeTask('t1');

      final active = await repository.getActiveTasks();
      expect(active.map((t) => t.id), ['t2']);

      final reloaded = TaskRepositoryLocal(
        store,
        clock: clock,
        idGenerator: ids,
      );
      final activeReloaded = await reloaded.getActiveTasks();
      expect(activeReloaded.map((t) => t.id), ['t2']);
    });

    test('delete removes task permanently', () async {
      await repository.createTask('Task A');
      await repository.createTask('Task B');

      await repository.deleteTask('t1');

      final active = await repository.getActiveTasks();
      expect(active.map((t) => t.id), ['t2']);

      final reloaded = TaskRepositoryLocal(
        store,
        clock: clock,
        idGenerator: ids,
      );
      final activeReloaded = await reloaded.getActiveTasks();
      expect(activeReloaded.map((t) => t.id), ['t2']);
    });

    test('reorder persists across reload', () async {
      await repository.createTask('Task A');
      await repository.createTask('Task B');
      await repository.createTask('Task C');

      clock.setNow(DateTime.utc(2026, 2, 22, 12, 20, 0));
      await repository.reorderTasks(['t3', 't1', 't2']);

      final active = await repository.getActiveTasks();
      expect(active.map((t) => t.id), ['t3', 't1', 't2']);

      final reloaded = TaskRepositoryLocal(
        store,
        clock: clock,
        idGenerator: ids,
      );
      final activeReloaded = await reloaded.getActiveTasks();
      expect(activeReloaded.map((t) => t.id), ['t3', 't1', 't2']);
    });
  });
}

import '../../../../core/time/clock.dart';
import '../../../../core/utils/ids.dart';
import '../../../../core/utils/uuid_id_generator.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/local_task_store.dart';
import '../models/task_model.dart';

class TaskRepositoryLocal implements TaskRepository {
  TaskRepositoryLocal(this._store, {Clock? clock, IdGenerator? idGenerator})
    : _clock = clock ?? SystemClock(),
      _idGenerator = idGenerator ?? UuidIdGenerator();

  final LocalTaskStore _store;
  final Clock _clock;
  final IdGenerator _idGenerator;

  @override
  Future<void> completeTask(String taskId) async {
    final tasks = await _readDomainTasks();
    final now = _clock.now();

    final updated = tasks
        .map(
          (task) => task.id == taskId
              ? task.copyWith(
                  isCompleted: true,
                  completedAt: now,
                  updatedAt: now,
                )
              : task,
        )
        .toList(growable: false);

    await _writeDomainTasks(updated);
  }

  @override
  Future<Task> createTask(String title) async {
    final tasks = await _readDomainTasks();
    final now = _clock.now();

    final nextSort = tasks.isEmpty
        ? 0
        : tasks.map((task) => task.sortOrder).reduce((a, b) => a > b ? a : b) +
              1;

    final created = Task(
      id: _idGenerator.next(),
      title: title,
      sortOrder: nextSort,
      isCompleted: false,
      createdAt: now,
      updatedAt: now,
    );

    await _writeDomainTasks([...tasks, created]);
    return created;
  }

  @override
  Future<void> deleteTask(String taskId) async {
    final tasks = await _readDomainTasks();
    final updated = tasks
        .where((task) => task.id != taskId)
        .toList(growable: false);
    await _writeDomainTasks(updated);
  }

  @override
  Future<List<Task>> getActiveTasks() async {
    final tasks = await _readDomainTasks();
    final active =
        tasks.where((task) => !task.isCompleted).toList(growable: false)
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return active;
  }

  @override
  Future<void> reorderTasks(List<String> orderedTaskIds) async {
    final tasks = await _readDomainTasks();

    final byId = {for (final task in tasks) task.id: task};
    final updated = <Task>[];
    final now = _clock.now();

    for (var index = 0; index < orderedTaskIds.length; index++) {
      final id = orderedTaskIds[index];
      final task = byId[id];
      if (task == null) continue;

      updated.add(task.copyWith(sortOrder: index, updatedAt: now));
      byId.remove(id);
    }

    // Keep remaining tasks (e.g., completed tasks) after explicitly ordered set.
    final remainder = byId.values.toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    var next = updated.length;
    for (final task in remainder) {
      updated.add(task.copyWith(sortOrder: next, updatedAt: now));
      next++;
    }

    await _writeDomainTasks(updated);
  }

  @override
  Future<Task> updateTask({
    required String taskId,
    required String title,
  }) async {
    final tasks = await _readDomainTasks();
    final now = _clock.now();

    Task? updatedTask;
    final updated = tasks
        .map((task) {
          if (task.id != taskId) return task;

          updatedTask = task.copyWith(title: title, updatedAt: now);
          return updatedTask!;
        })
        .toList(growable: false);

    if (updatedTask == null) {
      throw StateError('Task not found: $taskId');
    }

    await _writeDomainTasks(updated);
    return updatedTask!;
  }

  Future<List<Task>> _readDomainTasks() async {
    final models = await _store.readAll();
    return models.map((m) => m.toDomain()).toList(growable: false);
  }

  Future<void> _writeDomainTasks(List<Task> tasks) async {
    final models = tasks.map(TaskModel.fromDomain).toList(growable: false);
    await _store.writeAll(models);
  }

  LocalTaskStore get store => _store;
}

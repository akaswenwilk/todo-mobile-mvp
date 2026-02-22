import 'package:todo_mobile_mvp/features/tasks/domain/entities/task.dart';
import 'package:todo_mobile_mvp/features/tasks/domain/repositories/task_repository.dart';

class FakeTaskRepository implements TaskRepository {
  String? lastCreatedTitle;
  String? lastUpdatedTaskId;
  String? lastUpdatedTitle;
  String? lastCompletedTaskId;
  String? lastDeletedTaskId;
  List<String>? lastReorderIds;

  final List<Task> _tasks;

  FakeTaskRepository({List<Task>? tasks}) : _tasks = tasks ?? [];

  @override
  Future<void> completeTask(String taskId) async {
    lastCompletedTaskId = taskId;
  }

  @override
  Future<Task> createTask(String title) async {
    lastCreatedTitle = title;
    final task = Task(
      id: 'task-${_tasks.length + 1}',
      title: title,
      sortOrder: _tasks.length,
      isCompleted: false,
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );
    _tasks.add(task);
    return task;
  }

  @override
  Future<void> deleteTask(String taskId) async {
    lastDeletedTaskId = taskId;
  }

  @override
  Future<List<Task>> getActiveTasks() async {
    return _tasks.where((task) => !task.isCompleted).toList();
  }

  @override
  Future<void> reorderTasks(List<String> orderedTaskIds) async {
    lastReorderIds = orderedTaskIds;
  }

  @override
  Future<Task> updateTask({
    required String taskId,
    required String title,
  }) async {
    lastUpdatedTaskId = taskId;
    lastUpdatedTitle = title;

    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index == -1) {
      return Task(
        id: taskId,
        title: title,
        sortOrder: 0,
        isCompleted: false,
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 1),
      );
    }

    final updated = _tasks[index].copyWith(title: title);
    _tasks[index] = updated;
    return updated;
  }
}

import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/local_task_store.dart';

class TaskRepositoryLocal implements TaskRepository {
  TaskRepositoryLocal(this._store);

  final LocalTaskStore _store;

  @override
  Future<void> completeTask(String taskId) {
    throw UnimplementedError('Implemented in PR-02/03.');
  }

  @override
  Future<Task> createTask(String title) {
    throw UnimplementedError('Implemented in PR-02/03.');
  }

  @override
  Future<void> deleteTask(String taskId) {
    throw UnimplementedError('Implemented in PR-02/03.');
  }

  @override
  Future<List<Task>> getActiveTasks() {
    throw UnimplementedError('Implemented in PR-02/03.');
  }

  @override
  Future<void> reorderTasks(List<String> orderedTaskIds) {
    throw UnimplementedError('Implemented in PR-02/03.');
  }

  @override
  Future<Task> updateTask({required String taskId, required String title}) {
    throw UnimplementedError('Implemented in PR-02/03.');
  }

  LocalTaskStore get store => _store;
}

import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getActiveTasks();
  Future<Task> createTask(String title);
  Future<Task> updateTask({required String taskId, required String title});
  Future<void> completeTask(String taskId);
  Future<void> deleteTask(String taskId);
  Future<void> reorderTasks(List<String> orderedTaskIds);
}

import '../entities/task.dart';

class TaskVisibilityPolicy {
  const TaskVisibilityPolicy._();

  static List<Task> activeOnly(List<Task> tasks) {
    return tasks.where((task) => !task.isCompleted).toList(growable: false)
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }
}

import '../../domain/entities/task.dart';

class TaskListState {
  const TaskListState({required this.tasks});

  final List<Task> tasks;

  static const empty = TaskListState(tasks: []);
}

class TaskListNotifier {
  TaskListState _state = TaskListState.empty;

  TaskListState get state => _state;

  void replaceTasks(List<Task> tasks) {
    _state = TaskListState(tasks: tasks);
  }
}

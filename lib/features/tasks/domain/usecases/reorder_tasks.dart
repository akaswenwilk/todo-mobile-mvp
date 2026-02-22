import '../repositories/task_repository.dart';

class ReorderTasks {
  const ReorderTasks(this._repository);

  final TaskRepository _repository;

  Future<void> call(List<String> orderedTaskIds) {
    return _repository.reorderTasks(orderedTaskIds);
  }
}

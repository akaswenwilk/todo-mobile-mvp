import '../repositories/task_repository.dart';

class CompleteTask {
  const CompleteTask(this._repository);

  final TaskRepository _repository;

  Future<void> call(String taskId) => _repository.completeTask(taskId);
}

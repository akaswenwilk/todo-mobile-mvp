import '../errors/task_validation_exception.dart';
import '../repositories/task_repository.dart';

class DeleteTask {
  const DeleteTask(this._repository);

  final TaskRepository _repository;

  Future<void> call(String taskId) {
    if (taskId.trim().isEmpty) {
      throw TaskValidationException('Task id cannot be empty.');
    }

    return _repository.deleteTask(taskId);
  }
}

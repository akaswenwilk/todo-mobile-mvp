import '../entities/task.dart';
import '../errors/task_validation_exception.dart';
import '../repositories/task_repository.dart';
import '../value_objects/task_title.dart';

class UpdateTask {
  const UpdateTask(this._repository);

  final TaskRepository _repository;

  Future<Task> call({required String taskId, required String rawTitle}) {
    if (taskId.trim().isEmpty) {
      throw TaskValidationException('Task id cannot be empty.');
    }

    final title = TaskTitle.fromRaw(rawTitle);
    return _repository.updateTask(taskId: taskId, title: title.value);
  }
}

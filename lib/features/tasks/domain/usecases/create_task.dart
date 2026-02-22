import '../entities/task.dart';
import '../repositories/task_repository.dart';
import '../value_objects/task_title.dart';

class CreateTask {
  const CreateTask(this._repository);

  final TaskRepository _repository;

  Future<Task> call(String rawTitle) {
    final title = TaskTitle.fromRaw(rawTitle);
    return _repository.createTask(title.value);
  }
}

import '../entities/task.dart';
import '../repositories/task_repository.dart';

class CreateTask {
  const CreateTask(this._repository);

  final TaskRepository _repository;

  Future<Task> call(String title) => _repository.createTask(title);
}

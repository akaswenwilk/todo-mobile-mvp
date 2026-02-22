import '../entities/task.dart';
import '../repositories/task_repository.dart';

class UpdateTask {
  const UpdateTask(this._repository);

  final TaskRepository _repository;

  Future<Task> call({required String taskId, required String title}) {
    return _repository.updateTask(taskId: taskId, title: title);
  }
}

import '../errors/task_validation_exception.dart';
import '../repositories/task_repository.dart';

class ReorderTasks {
  const ReorderTasks(this._repository);

  final TaskRepository _repository;

  Future<void> call(List<String> orderedTaskIds) {
    final normalized = orderedTaskIds.map((id) => id.trim()).toList();

    if (normalized.any((id) => id.isEmpty)) {
      throw TaskValidationException(
        'Task ids cannot be empty when reordering.',
      );
    }

    if (normalized.toSet().length != normalized.length) {
      throw TaskValidationException('Task ids must be unique when reordering.');
    }

    return _repository.reorderTasks(normalized);
  }
}

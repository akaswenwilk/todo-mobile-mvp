import '../errors/task_validation_exception.dart';

class TaskTitle {
  TaskTitle._(this.value);

  static const int maxLength = 280;

  final String value;

  factory TaskTitle.fromRaw(String raw) {
    final normalized = raw.trim();

    if (normalized.isEmpty) {
      throw TaskValidationException(
        'Task title cannot be empty or whitespace.',
      );
    }

    if (normalized.length > maxLength) {
      throw TaskValidationException(
        'Task title cannot exceed $maxLength characters.',
      );
    }

    return TaskTitle._(normalized);
  }
}

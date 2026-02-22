import '../../domain/entities/task.dart';

class TaskModel {
  const TaskModel({
    required this.id,
    required this.title,
    required this.sortOrder,
    required this.isCompleted,
    required this.createdAtMillis,
    required this.updatedAtMillis,
    this.completedAtMillis,
  });

  final String id;
  final String title;
  final int sortOrder;
  final bool isCompleted;
  final int createdAtMillis;
  final int updatedAtMillis;
  final int? completedAtMillis;

  factory TaskModel.fromDomain(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      sortOrder: task.sortOrder,
      isCompleted: task.isCompleted,
      createdAtMillis: task.createdAt.millisecondsSinceEpoch,
      updatedAtMillis: task.updatedAt.millisecondsSinceEpoch,
      completedAtMillis: task.completedAt?.millisecondsSinceEpoch,
    );
  }

  Task toDomain() {
    return Task(
      id: id,
      title: title,
      sortOrder: sortOrder,
      isCompleted: isCompleted,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMillis),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAtMillis),
      completedAt: completedAtMillis == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(completedAtMillis!),
    );
  }
}

class PendingTaskDeletion {
  const PendingTaskDeletion({
    required this.taskId,
    required this.requestedAt,
    required this.expiresAt,
  });

  final String taskId;
  final DateTime requestedAt;
  final DateTime expiresAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

class TaskDeletionBuffer {
  TaskDeletionBuffer({required this.undoWindow})
    : assert(!undoWindow.isNegative);

  final Duration undoWindow;
  final Map<String, PendingTaskDeletion> _pending = {};

  PendingTaskDeletion request({required String taskId, required DateTime now}) {
    final deletion = PendingTaskDeletion(
      taskId: taskId,
      requestedAt: now,
      expiresAt: now.add(undoWindow),
    );

    _pending[taskId] = deletion;
    return deletion;
  }

  bool undo(String taskId) {
    return _pending.remove(taskId) != null;
  }

  List<String> consumeExpired(DateTime now) {
    final expiredIds = _pending.values
        .where((deletion) => !now.isBefore(deletion.expiresAt))
        .map((deletion) => deletion.taskId)
        .toList(growable: false);

    for (final id in expiredIds) {
      _pending.remove(id);
    }

    return expiredIds;
  }

  bool isPending(String taskId) => _pending.containsKey(taskId);
}

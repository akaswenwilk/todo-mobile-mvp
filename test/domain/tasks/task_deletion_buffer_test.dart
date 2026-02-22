import 'package:flutter_test/flutter_test.dart';
import 'package:todo_mobile_mvp/features/tasks/domain/services/task_deletion_buffer.dart';

void main() {
  group('TaskDeletionBuffer', () {
    test('tracks pending deletion and allows undo before expiry', () {
      final now = DateTime.utc(2026, 2, 22, 10);
      final buffer = TaskDeletionBuffer(undoWindow: const Duration(seconds: 5));

      final pending = buffer.request(taskId: 't1', now: now);

      expect(pending.expiresAt, now.add(const Duration(seconds: 5)));
      expect(buffer.isPending('t1'), isTrue);

      final undone = buffer.undo('t1');
      expect(undone, isTrue);
      expect(buffer.isPending('t1'), isFalse);
    });

    test('returns expired task ids and clears them', () {
      final now = DateTime.utc(2026, 2, 22, 10);
      final buffer = TaskDeletionBuffer(undoWindow: const Duration(seconds: 5));

      buffer.request(taskId: 't1', now: now);
      buffer.request(taskId: 't2', now: now.add(const Duration(seconds: 2)));

      final expired = buffer.consumeExpired(
        now.add(const Duration(seconds: 6)),
      );

      expect(expired, ['t1']);
      expect(buffer.isPending('t1'), isFalse);
      expect(buffer.isPending('t2'), isTrue);
    });
  });
}

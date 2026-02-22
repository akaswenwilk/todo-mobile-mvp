import 'package:flutter_test/flutter_test.dart';
import 'package:todo_mobile_mvp/features/tasks/domain/errors/task_validation_exception.dart';
import 'package:todo_mobile_mvp/features/tasks/domain/value_objects/task_title.dart';

void main() {
  group('TaskTitle', () {
    test('accepts valid title and trims surrounding whitespace', () {
      final title = TaskTitle.fromRaw('  Ship MVP this week  ');

      expect(title.value, 'Ship MVP this week');
    });

    test('rejects empty input', () {
      expect(
        () => TaskTitle.fromRaw(''),
        throwsA(isA<TaskValidationException>()),
      );
    });

    test('rejects whitespace-only input', () {
      expect(
        () => TaskTitle.fromRaw('   \n\t  '),
        throwsA(isA<TaskValidationException>()),
      );
    });

    test('allows exactly 280 chars and rejects >280', () {
      final valid = 'a' * TaskTitle.maxLength;
      final tooLong = 'b' * (TaskTitle.maxLength + 1);

      expect(TaskTitle.fromRaw(valid).value.length, TaskTitle.maxLength);
      expect(
        () => TaskTitle.fromRaw(tooLong),
        throwsA(isA<TaskValidationException>()),
      );
    });

    test('preserves multiline content', () {
      final title = TaskTitle.fromRaw('Line 1\nLine 2');
      expect(title.value, 'Line 1\nLine 2');
    });
  });
}

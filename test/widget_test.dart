import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_mobile_mvp/app/app.dart';
import 'package:todo_mobile_mvp/app/theme/app_theme.dart';
import 'package:todo_mobile_mvp/features/tasks/presentation/screens/task_list_screen.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const TodoApp());
    await tester.pumpAndSettle();
  }

  Future<void> addTask(WidgetTester tester, String title) async {
    await tester.tap(find.byKey(TaskListScreen.fabKey));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(TaskListScreen.addTaskInputKey), title);
    await tester.tap(find.byKey(TaskListScreen.addTaskSaveKey));
    await tester.pumpAndSettle();
  }

  testWidgets('M01 app launches to main list screen', (tester) async {
    await pumpApp(tester);

    expect(find.text('Today'), findsOneWidget);
    expect(find.byType(TaskListScreen), findsOneWidget);
  });

  testWidgets('M02 dark theme is applied', (tester) async {
    await pumpApp(tester);

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.theme?.brightness, Brightness.dark);
    expect(materialApp.theme?.scaffoldBackgroundColor, AppTheme.background);
  });

  testWidgets('M03 FAB is visible and no bottom status strip exists', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(find.byKey(TaskListScreen.fabKey), findsOneWidget);
    expect(find.byKey(TaskListScreen.bottomStatusStripKey), findsNothing);
  });

  testWidgets('M04 + M05 tapping FAB opens add input and saves task', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.byKey(TaskListScreen.fabKey));
    await tester.pumpAndSettle();

    expect(find.byKey(TaskListScreen.addTaskInputKey), findsOneWidget);

    await tester.enterText(
      find.byKey(TaskListScreen.addTaskInputKey),
      'Ship PR-04',
    );
    await tester.tap(find.byKey(TaskListScreen.addTaskSaveKey));
    await tester.pumpAndSettle();

    expect(find.text('Ship PR-04'), findsOneWidget);
  });

  testWidgets('M11 + M12 inline edit updates visible task text', (
    tester,
  ) async {
    await pumpApp(tester);
    await addTask(tester, 'Original task');

    await tester.tap(find.text('Original task'));
    await tester.pumpAndSettle();

    expect(find.byKey(TaskListScreen.editTaskInputKey), findsOneWidget);

    await tester.enterText(
      find.byKey(TaskListScreen.editTaskInputKey),
      'Updated task title',
    );
    await tester.tap(find.byKey(TaskListScreen.editTaskSaveKey));
    await tester.pumpAndSettle();

    expect(find.text('Updated task title'), findsOneWidget);
    expect(find.text('Original task'), findsNothing);
  });

  testWidgets('M14 complete action removes task from active list', (
    tester,
  ) async {
    await pumpApp(tester);
    await addTask(tester, 'Task to complete');

    await tester.tap(find.byKey(TaskListScreen.completeTaskButtonKey).first);
    await tester.pumpAndSettle();

    expect(find.text('Task to complete'), findsNothing);
    expect(find.byKey(TaskListScreen.emptyStateKey), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_mobile_mvp/app/app.dart';
import 'package:todo_mobile_mvp/app/theme/app_theme.dart';
import 'package:todo_mobile_mvp/features/tasks/presentation/screens/task_list_screen.dart';

void main() {
  testWidgets('M01 app launches to main list screen', (tester) async {
    await tester.pumpWidget(const TodoApp());

    expect(find.text('Today'), findsOneWidget);
    expect(find.byType(TaskListScreen), findsOneWidget);
  });

  testWidgets('M02 dark theme is applied', (tester) async {
    await tester.pumpWidget(const TodoApp());

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.theme?.brightness, Brightness.dark);

    expect(materialApp.theme?.scaffoldBackgroundColor, AppTheme.background);
  });

  testWidgets('M03 FAB is visible and no bottom status strip exists', (
    tester,
  ) async {
    await tester.pumpWidget(const TodoApp());

    expect(find.byKey(TaskListScreen.fabKey), findsOneWidget);
    expect(find.byKey(TaskListScreen.bottomStatusStripKey), findsNothing);
  });
}

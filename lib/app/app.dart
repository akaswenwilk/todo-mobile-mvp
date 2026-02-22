import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import '../features/tasks/presentation/screens/task_list_screen.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus List',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const TaskListScreen(),
    );
  }
}

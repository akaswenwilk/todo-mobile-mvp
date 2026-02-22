import 'package:flutter/material.dart';
import 'package:todo_mobile_mvp/features/tasks/domain/repositories/task_repository.dart';

import '../features/tasks/presentation/screens/task_list_screen.dart';
import 'theme/app_theme.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({super.key, this.repository});

  final TaskRepository? repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus List',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: TaskListScreen(repository: repository),
    );
  }
}

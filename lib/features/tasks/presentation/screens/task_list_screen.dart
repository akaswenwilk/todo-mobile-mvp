import 'package:flutter/material.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  static const fabKey = Key('task_list_fab');
  static const emptyStateKey = Key('task_list_empty_state');
  static const bottomStatusStripKey = Key('bottom_status_strip');

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text('Today', style: textTheme.titleLarge)),
      body: const SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Nothing here yet\nAdd your first task to clear your mind.',
                  key: emptyStateKey,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: fabKey,
        onPressed: () {
          // PR-01 scaffold only; add flow arrives in later PR.
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:todo_mobile_mvp/features/tasks/data/datasources/in_memory_task_store.dart';
import 'package:todo_mobile_mvp/features/tasks/data/repositories/task_repository_local.dart';
import 'package:todo_mobile_mvp/features/tasks/domain/entities/task.dart';
import 'package:todo_mobile_mvp/features/tasks/domain/errors/task_validation_exception.dart';
import 'package:todo_mobile_mvp/features/tasks/domain/repositories/task_repository.dart';
import 'package:todo_mobile_mvp/features/tasks/domain/usecases/complete_task.dart';
import 'package:todo_mobile_mvp/features/tasks/domain/usecases/create_task.dart';
import 'package:todo_mobile_mvp/features/tasks/domain/usecases/delete_task.dart';
import 'package:todo_mobile_mvp/features/tasks/domain/usecases/reorder_tasks.dart';
import 'package:todo_mobile_mvp/features/tasks/domain/usecases/update_task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key, this.repository});

  final TaskRepository? repository;

  static const fabKey = Key('task_list_fab');
  static const emptyStateKey = Key('task_list_empty_state');
  static const bottomStatusStripKey = Key('bottom_status_strip');
  static const addTaskInputKey = Key('add_task_input');
  static const addTaskSaveKey = Key('add_task_save');
  static const editTaskInputKey = Key('edit_task_input');
  static const editTaskSaveKey = Key('edit_task_save');
  static const completeTaskButtonKey = Key('complete_task_button');
  static const deleteTaskButtonKey = Key('delete_task_button');

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late final TaskRepository _repository;
  late final CreateTask _createTask;
  late final UpdateTask _updateTask;
  late final CompleteTask _completeTask;
  late final DeleteTask _deleteTask;
  late final ReorderTasks _reorderTasks;

  List<Task> _tasks = const [];
  bool _isLoading = true;
  String? _editingTaskId;
  TextEditingController? _editingController;
  FocusNode? _editingFocusNode;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? TaskRepositoryLocal(InMemoryTaskStore());
    _createTask = CreateTask(_repository);
    _updateTask = UpdateTask(_repository);
    _completeTask = CompleteTask(_repository);
    _deleteTask = DeleteTask(_repository);
    _reorderTasks = ReorderTasks(_repository);
    _loadTasks();
  }

  @override
  void dispose() {
    _editingController?.dispose();
    _editingFocusNode?.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    final tasks = await _repository.getActiveTasks();
    if (!mounted) return;

    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
  }

  Future<void> _onAddTask(String rawTitle) async {
    await _createTask(rawTitle);
    await _loadTasks();
  }

  void _startEditing(Task task) {
    _editingController?.dispose();
    _editingFocusNode?.dispose();

    _editingController = TextEditingController(text: task.title);
    _editingFocusNode = FocusNode();

    setState(() {
      _editingTaskId = task.id;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _editingFocusNode?.requestFocus();
    });
  }

  Future<void> _saveEdit(Task task) async {
    try {
      await _updateTask(
        taskId: task.id,
        rawTitle: _editingController?.text ?? '',
      );
      _editingController?.dispose();
      _editingController = null;
      _editingFocusNode?.dispose();
      _editingFocusNode = null;
      if (!mounted) return;

      setState(() {
        _editingTaskId = null;
      });

      await _loadTasks();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid task title.')),
      );
    }
  }

  Future<void> _onComplete(Task task) async {
    await _completeTask(task.id);
    await _loadTasks();
  }

  Future<void> _onReorder(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final reordered = List<Task>.from(_tasks);
    final moved = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, moved);

    if (_editingTaskId == moved.id) {
      _editingController?.dispose();
      _editingFocusNode?.dispose();
      _editingController = null;
      _editingFocusNode = null;
      _editingTaskId = null;
    }

    setState(() {
      _tasks = reordered;
    });

    try {
      await _reorderTasks(reordered.map((task) => task.id).toList());
      await _loadTasks();
    } catch (_) {
      await _loadTasks();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not reorder tasks. Try again.')),
      );
    }
  }

  Future<void> _onDeleteRequested(Task task) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete task?'),
              content: const Text('You can undo this right after deleting.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!confirmed) return;

    final previousIndex = _tasks.indexWhere((t) => t.id == task.id);
    if (previousIndex == -1) return;

    if (_editingTaskId == task.id) {
      _editingController?.dispose();
      _editingFocusNode?.dispose();
      _editingController = null;
      _editingFocusNode = null;
      _editingTaskId = null;
    }

    setState(() {
      _tasks = _tasks.where((t) => t.id != task.id).toList(growable: false);
    });

    var undone = false;
    final messenger = ScaffoldMessenger.of(context);
    final snackController = messenger.showSnackBar(
      SnackBar(
        content: Text('Deleted "${task.title}"'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            undone = true;
            if (!mounted) return;

            setState(() {
              final restored = List<Task>.from(_tasks);
              final insertAt = math.min(previousIndex, restored.length);
              restored.insert(insertAt, task);
              _tasks = restored;
            });
          },
        ),
      ),
    );

    final reason = await snackController.closed;
    if (undone || reason == SnackBarClosedReason.action) {
      return;
    }

    try {
      await _deleteTask(task.id);
      await _loadTasks();
    } catch (_) {
      await _loadTasks();
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not delete task. Try again.')),
      );
    }
  }

  Future<void> _openAddSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _AddTaskSheet(
          onSubmit: (title) async {
            await _onAddTask(title);
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text('Today', style: textTheme.titleLarge)),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _tasks.isEmpty
            ? const Center(
                child: Text(
                  'Nothing here yet\nAdd your first task to clear your mind.',
                  key: TaskListScreen.emptyStateKey,
                  textAlign: TextAlign.center,
                ),
              )
            : ReorderableListView.builder(
                padding: const EdgeInsets.all(16),
                buildDefaultDragHandles: false,
                itemCount: _tasks.length,
                onReorder: _onReorder,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  final isEditing = _editingTaskId == task.id;

                  return Container(
                    key: ValueKey('task-row-${task.id}'),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        IconButton(
                          key: TaskListScreen.completeTaskButtonKey,
                          tooltip: 'Complete task',
                          onPressed: () => _onComplete(task),
                          icon: const Icon(Icons.radio_button_unchecked),
                        ),
                        Expanded(
                          child: isEditing
                              ? TextField(
                                  key: TaskListScreen.editTaskInputKey,
                                  controller: _editingController,
                                  focusNode: _editingFocusNode,
                                  maxLines: null,
                                  autofocus: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Edit task title',
                                  ),
                                )
                              : GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => _startEditing(task),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: Text(task.title, softWrap: true),
                                  ),
                                ),
                        ),
                        if (isEditing)
                          IconButton(
                            key: TaskListScreen.editTaskSaveKey,
                            tooltip: 'Save task edits',
                            onPressed: () => _saveEdit(task),
                            icon: const Icon(Icons.check),
                          )
                        else
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                key: TaskListScreen.deleteTaskButtonKey,
                                tooltip: 'Delete task',
                                onPressed: () => _onDeleteRequested(task),
                                icon: const Icon(Icons.delete_outline),
                              ),
                              ReorderableDragStartListener(
                                index: index,
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Icon(Icons.drag_indicator),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        key: TaskListScreen.fabKey,
        tooltip: 'Add task',
        onPressed: _openAddSheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _AddTaskSheet extends StatefulWidget {
  const _AddTaskSheet({required this.onSubmit});

  final Future<void> Function(String rawTitle) onSubmit;

  @override
  State<_AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<_AddTaskSheet> {
  final _controller = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _errorText = null;
    });

    final raw = _controller.text;
    final normalized = raw.trim();

    if (normalized.isEmpty) {
      setState(() {
        _errorText = 'Please enter a valid task title.';
      });
      return;
    }

    if (normalized.length > 280) {
      setState(() {
        _errorText = 'Task title must be 280 characters or fewer.';
      });
      return;
    }

    try {
      await widget.onSubmit(raw);
    } on TaskValidationException catch (e) {
      setState(() {
        _errorText = e.message;
      });
    } catch (e) {
      setState(() {
        _errorText = 'Could not save task: ${_friendlyError(e)}';
      });
    }
  }

  String _friendlyError(Object error) {
    final message = error.toString().trim();
    if (message.isEmpty) {
      return 'unknown error';
    }

    return message;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            key: TaskListScreen.addTaskInputKey,
            controller: _controller,
            autofocus: true,
            maxLines: null,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              labelText: 'Task title',
              hintText: 'What needs to get done?',
              errorText: _errorText,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              key: TaskListScreen.addTaskSaveKey,
              onPressed: _submit,
              child: const Text('Add'),
            ),
          ),
        ],
      ),
    );
  }
}

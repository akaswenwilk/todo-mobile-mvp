import '../models/task_model.dart';
import 'local_task_store.dart';

class InMemoryTaskStore implements LocalTaskStore {
  List<TaskModel> _data = [];

  @override
  Future<List<TaskModel>> readAll() async {
    return List<TaskModel>.from(_data);
  }

  @override
  Future<void> writeAll(List<TaskModel> tasks) async {
    _data = List<TaskModel>.from(tasks);
  }
}

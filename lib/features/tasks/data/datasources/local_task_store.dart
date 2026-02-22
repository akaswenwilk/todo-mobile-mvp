import '../models/task_model.dart';

abstract class LocalTaskStore {
  Future<List<TaskModel>> readAll();
  Future<void> writeAll(List<TaskModel> tasks);
}

import 'dart:developer' show log;

import 'package:stoodee/services/local_crud/crud_exceptions.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_task.dart';

class TodoService {
  late final List<DatabaseTask>? _tasks;
  bool _initialized = false;

  //ToDoService should be only used via singleton //
  static final TodoService _shared = TodoService._sharedInstance();
  factory TodoService() => _shared;
  TodoService._sharedInstance();
  //ToDoService should be only used via singleton //

  Future<List<DatabaseTask>> loadTasks() async {
    if (!_initialized) {
      _tasks = await LocalDbController().getUserTasks(
        LocalDbController().currentUser,
      );
      _initialized = true;
    }

    //FIXME: debug log
    String debugLogStart = "[START] loading tasks [START]\n\n";
    String debugLogTasks = "$_tasks\n\n";
    String debugLogEnd = "[END] loading tasks [END]\n.";

    log(debugLogStart + debugLogTasks + debugLogEnd);

    return _tasks!;
  }

  Future<DatabaseTask> createTask({required String text}) async {
    if (!_initialized) throw TodoServiceNotInitialized();

    final task = await LocalDbController().createTask(
      owner: LocalDbController().currentUser,
      text: text,
    );

    _tasks!.add(task);
    return task;
  }

  Future<void> removeTask(DatabaseTask task) async {
    if (!_initialized) throw TodoServiceNotInitialized();

    await LocalDbController().deleteTask(task: task);
    _tasks!.removeWhere((taskToRemove) => taskToRemove == task);
  }

  Future<void> updateTask({
    required DatabaseTask task,
    required String text,
  }) async {
    if (!_initialized) throw TodoServiceNotInitialized();

    await LocalDbController().updateTask(task: task, text: text);
  }

  List<DatabaseTask> get tasks {
    if (!_initialized) throw TodoServiceNotInitialized();

    return _tasks!;
  }

  Future<void> incrTasksCompletedToday() async {
    await LocalDbController().incrTasksCompletedToday(
      user: LocalDbController().currentUser,
    );
  }
}

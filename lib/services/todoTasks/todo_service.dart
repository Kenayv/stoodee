import 'dart:developer' show log;

import 'package:stoodee/services/local_crud/crud_exceptions.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_task.dart';

class TodoService {
  late List<Task>? _tasks;
  bool _initialized = false;

  //ToDoService should be only used via singleton //
  static final TodoService _shared = TodoService._sharedInstance();
  factory TodoService() => _shared;
  TodoService._sharedInstance();
  //ToDoService should be only used via singleton //

  Future<List<Task>> getTasks() async {
    if (!_initialized) {
      _tasks = await LocalDbController().getUserTasks(
        user: LocalDbController().currentUser,
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

  Future<void> reloadTasks() async {
    _tasks = null;

    _tasks = await LocalDbController().getUserTasks(
      user: LocalDbController().currentUser,
    );
  }

  Future<Task> createTask({required String text}) async {
    if (!_initialized) throw TodoServiceNotInitialized();

    final task = await LocalDbController().createTask(
      user: LocalDbController().currentUser,
      text: text,
    );

    _tasks!.add(task);
    return task;
  }

  Future<void> removeTask(Task task) async {
    if (!_initialized) throw TodoServiceNotInitialized();

    await LocalDbController().deleteTask(task: task);
    _tasks!.removeWhere((taskToRemove) => taskToRemove == task);
  }

  Future<void> updateTask({
    required Task task,
    required String text,
  }) async {
    if (!_initialized) throw TodoServiceNotInitialized();

    await LocalDbController().updateTaskText(task: task, text: text);
  }

  List<Task> get tasks {
    if (!_initialized) throw TodoServiceNotInitialized();

    return _tasks!;
  }

  Future<void> incrTasksCompleted() async {
    final user = LocalDbController().currentUser;

    if (!LocalDbController().isNullUser(user)) {
      await LocalDbController().incrUserTasksCompleted(user: user);
    }
  }

  Future<void> incrIncompleteTasks() async {
    final user = LocalDbController().currentUser;

    if (!LocalDbController().isNullUser(user)) {
      await LocalDbController().incrUserIncompleteTasks(user: user);
    }
  }
}

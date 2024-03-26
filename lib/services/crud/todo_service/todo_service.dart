import 'package:stoodee/services/crud/local_database_service/database_controller.dart';
import 'package:stoodee/services/crud/local_database_service/database_task.dart';
import 'package:stoodee/services/crud/todo_service/todo_exceptions.dart';

class TodoService {
  late final List<DatabaseTask> _tasks;
  bool _initialized = false;

  //ToDoService should be only used via singleton //
  static final TodoService _shared = TodoService._sharedInstance();
  factory TodoService() => _shared;
  TodoService._sharedInstance();
  //ToDoService should be only used via singleton //

  Future<void> init() async {
    if (_initialized) throw TodoServiceAlreadyInitialized;

    await loadTasks();

    _initialized = true;
  }

  Future<void> saveTasks() async {
    if (!_initialized) throw TodoServiceNotInitialized();

    //FIXME:
  }

  Future<void> loadTasks() async {
    _tasks = await DatabaseController().getAllDbTasks();
  }

  // Future<DatabaseTask> addTask({required String text}) async {
  //   if (!_initialized) throw TodoServiceNotInitialized();

  //   final task = await DatabaseController().createTask(
  //     owner: DatabaseController().currentUser,
  //     text: text,
  //   );

  //   _tasks.add(task);
  //   return task;
  // }

  Future<void> deleteTask({required DatabaseTask task}) async {
    if (!_initialized) throw TodoServiceNotInitialized();

    await DatabaseController().deleteTask(id: task.id);
  }

  Future<void> removeTask(DatabaseTask task) async {
    if (!_initialized) throw TodoServiceNotInitialized();

    await DatabaseController().deleteTask(id: task.id);
  }

  Future<void> updateTask({
    required DatabaseTask task,
    required String text,
  }) async {
    await DatabaseController().updateTask(task: task, text: text);
  }

  DatabaseTask taskAt(index) =>
      _initialized ? _tasks[index] : throw TodoServiceNotInitialized();

  List<DatabaseTask> get tasks =>
      _initialized ? _tasks : throw TodoServiceNotInitialized();
}

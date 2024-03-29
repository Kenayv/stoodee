import 'package:stoodee/services/crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/services/crud/local_database_service/database_task.dart';
import 'package:stoodee/services/crud/todo_service/todo_exceptions.dart';
import 'package:stoodee/services/currentUser/user.dart';

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

  Future<void> syncWithCloud() async {
    if (!_initialized) throw TodoServiceNotInitialized();
    //FIXME:
  }

  Future<void> loadTasks() async {
    _tasks = await LocalDbController().getAllDbTasks();
  }

  Future<DatabaseTask> createTask({required String text}) async {
    if (!_initialized) throw TodoServiceNotInitialized();

    final task = await LocalDbController().createTask(
      owner: CurrentUser().currentUser!,
      text: text,
    );

    _tasks.add(task);
    return task;
  }

  Future<void> deleteTask({required DatabaseTask task}) async {
    if (!_initialized) throw TodoServiceNotInitialized();

    await LocalDbController().deleteTask(id: task.id);
  }

  Future<void> removeTask(DatabaseTask task) async {
    if (!_initialized) throw TodoServiceNotInitialized();

    await LocalDbController().deleteTask(id: task.id);
    _tasks.removeWhere((taskToRemove) => taskToRemove == task);
  }

  Future<void> updateTask({
    required DatabaseTask task,
    required String text,
  }) async {
    await LocalDbController().updateTask(task: task, text: text);
  }

  DatabaseTask taskAt(index) {
    if (_initialized == false) throw TodoServiceNotInitialized();
    if (index > _tasks.length - 1 || index < 0) throw RangeError("Range error");

    return _tasks[index];
  }

  List<DatabaseTask> get tasks =>
      _initialized ? _tasks : throw TodoServiceNotInitialized();
}

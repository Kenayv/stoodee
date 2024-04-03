import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_task.dart';
import 'package:stoodee/services/local_crud/todo_service/todo_exceptions.dart';

class TodoService {
  late List<DatabaseTask> _tasks;
  bool _initialized = false;

  //ToDoService should be only used via singleton //
  static final TodoService _shared = TodoService._sharedInstance();
  factory TodoService() => _shared;
  TodoService._sharedInstance();
  //ToDoService should be only used via singleton //

  Future<void> init() async {
    if (_initialized) throw TodoServiceAlreadyInitialized;

    //FIXME: nic sie nie dzieje uwu

    _initialized = true;
  }

  Future<void> syncWithCloud() async {
    if (!_initialized) throw TodoServiceNotInitialized();
    //FIXME:
  }

  Future<List<DatabaseTask>> loadTasks() async {
    _tasks =
        await LocalDbController().getUserTasks(LocalDbController().currentUser);

    //FIXME: debug print
    print("STARTED: loading tasks:\n\n");
    print('$_tasks');
    print("\nENDED Loading tasks\n");

    return _tasks;
  }

  Future<DatabaseTask> createTask({required String text}) async {
    if (!_initialized) throw TodoServiceNotInitialized();

    final task = await LocalDbController().createTask(
      owner: LocalDbController().currentUser,
      text: text,
    );

    _tasks.add(task);
    return task;
  }

  //FIXME: why is it repeated????
  Future<void> deleteTask({required DatabaseTask task}) async {
    if (!_initialized) throw TodoServiceNotInitialized();

    await LocalDbController().deleteTask(id: task.id);
  }

  //FIXME: why is it repeated????
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

  List<DatabaseTask> get tasks {
    for (DatabaseTask task in _tasks) {
      print('returning $task');
    }
    return _initialized ? _tasks : throw TodoServiceNotInitialized();
  }
}

import 'package:flutter/material.dart';
import 'package:stoodee/services/crud/todo_service/consts.dart';
import 'package:stoodee/services/crud/todo_service/todo_exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class TodoService {
  late final List<String> _tasks;
  bool _initialized = false;
  Database? _db;
  //FIXME:
  Future<void> init() async {
    if (_initialized) throw TodoServiceAlreadyInitialized;

    await openDb();
    await loadTasks();

    _initialized = true;
  }

  //ToDoService should be only used via singleton //
  static final TodoService _shared = TodoService._sharedInstance();
  factory TodoService() => _shared;
  TodoService._sharedInstance();
  //ToDoService should be only used via singleton //

  Future<void> openDb() async {
    if (_db != null) throw DatabaseAlreadyOpened();

    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);

      _db = await openDatabase(dbPath);

      await _db!.execute(createUserTable);
      await _db!.execute(createTaskTable);
    } on MissingPlatformDirectoryException {
      print('Could not open database!');
    } catch (e) {
      print('error ${e.toString()}');
    }
  }

  Future<void> closeDb() async {
    if (_db == null) throw DatabaseIsNotOpened();

    await _db!.close();
    _db = null;
  }

  Database _getDatabaseOrThrow() {
    if (_db == null) throw DatabaseIsNotOpened();

    return _db!;
  }

  Future<void> saveTasks() async {
    if (!_initialized) throw TodoServiceNotInitialized();

    //FIXME:
  }

  Future<void> loadTasks() async {
    _tasks = [
      "Incomplete Task 1",
      "debug Task 2",
      "Incomplete Task 3",
      "debug Task 4",
      "Incomplete Task 5"
    ];

    //FIXME:
  }

  Future<void> addTask(String task) async {
    if (!_initialized) throw TodoServiceNotInitialized();

    _tasks.add(task);

    await saveTasks();
  }

  Future<void> removeTaskAt(int index) async {
    if (!_initialized) throw TodoServiceNotInitialized();

    _tasks.removeAt(index);

    await saveTasks();
  }

  Future<void> editTaskAt(int index, String newText) async {
    if (!_initialized) throw TodoServiceNotInitialized();

    _tasks[index] = newText;

    await saveTasks();
  }

  String taskAt(index) =>
      _initialized ? _tasks[index] : throw TodoServiceNotInitialized();

  List<String> get tasks =>
      _initialized ? _tasks : throw TodoServiceNotInitialized();
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({required this.id, required this.email});

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'User, ID = [$id], email = [$email] ';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseTask {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseTask({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });

  DatabaseTask.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Task\n id = [$id],\nuserId = [$userId],\ntext = [$text],\nisSyncedWithCloud = [$isSyncedWithCloud]';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

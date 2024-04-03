import 'package:stoodee/services/auth/auth_service.dart';
import 'package:stoodee/services/local_crud/crud_exceptions.dart';
import 'package:stoodee/services/local_crud/local_database_service/consts.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_task.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class LocalDbController {
  Database? _db;
  DatabaseUser? _currentUser;

  //Database Service should be only used via singleton //
  static final LocalDbController _shared = LocalDbController._sharedInstance();
  factory LocalDbController() => _shared;
  LocalDbController._sharedInstance();
  //Database Service should be only used via singleton //

  Future<void> init() async {
    await openDb();
    await initNullUser();

    final String userEmail =
        AuthService.firebase().currentUser?.email ?? notLoggedInUserEmail;

    _currentUser = await getUserOrNull(email: userEmail) ?? await getNullUser();
  }

  //Current user is set to nullUser before logging in.
  Future<void> initNullUser() async {
    DatabaseUser? nullUser = await getUserOrNull(email: notLoggedInUserEmail);
    nullUser ??= await createUser(email: notLoggedInUserEmail);
  }

  Future<void> openDb() async {
    if (_db != null) throw DatabaseAlreadyOpened();

    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);

      _db = await openDatabase(dbPath);

      await _db!.execute(createUserTable);
      await _db!.execute(createTaskTable);
      await _db!.execute(createFlashcardSetTable);
      await _db!.execute(createFlashcardTable);
    } on MissingPlatformDirectoryException {
      print('Could not open database!');
      rethrow;
    } catch (e) {
      print('error ${e.toString()}');
      rethrow;
    }
  }

  Future<void> closeDb() async {
    if (_db == null) throw DatabaseIsNotOpened();

    await _db!.close();
    _db = null;
    _currentUser = null;
  }

  Database _getDatabaseOrThrow() {
    if (_db == null) throw DatabaseIsNotOpened();
    return _db!;
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (deletedCount != 1) throw CouldNotDeleteUser();
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();

    final result = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (result.isNotEmpty) throw UserAlreadyExists();

    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });

    return DatabaseUser(
      id: userId,
      email: email,
    );
  }

  Future<DatabaseUser> createOrLoginAndSetUser({required String email}) async {
    DatabaseUser? user = await getUserOrNull(email: email);

    user ??= await createUser(email: email);
    setCurrentUser(user);

    return user;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final DatabaseUser? user = await getUserOrNull(email: email);

    if (user == null) throw CouldNotFindUser();

    return user;
  }

  Future<DatabaseUser?> getUserOrNull({required String email}) async {
    final db = _getDatabaseOrThrow();

    final result = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (result.isEmpty) return null;

    return DatabaseUser.fromRow(result.first);
  }

  Future<DatabaseTask> createTask({
    required DatabaseUser owner,
    required String text,
  }) async {
    final db = _getDatabaseOrThrow();
    final dbUser = await getUser(email: owner.email);

    //make sure owner exists in database and isn't hard-coded
    if (dbUser != owner) throw CouldNotFindUser();

    final taskId = await db.insert(taskTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });

    final task = DatabaseTask(
      id: taskId,
      userId: owner.id,
      text: text,
      isSyncedWithCloud: false,
    );

    return task;
  }

  Future<void> deleteTask({required int id}) async {
    final db = _getDatabaseOrThrow();

    final deletedCount = await db.delete(
      taskTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (deletedCount != 1) throw CouldNotDeleteTask();
  }

  Future<DatabaseTask> getDbTask({required int id}) async {
    final db = _getDatabaseOrThrow();

    final task = await db.query(
      taskTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (task.isEmpty) throw CouldNotFindTask();

    return DatabaseTask.fromRow(task.first);
  }

  Future<List<DatabaseTask>> _getAllDbTasks() async {
    final db = _getDatabaseOrThrow();
    final tasks = await db.query(taskTable);

    return tasks.map((taskRow) => DatabaseTask.fromRow(taskRow)).toList();
  }

  Future<List<DatabaseTask>> getUserTasks(DatabaseUser user) async {
    List<DatabaseTask> allTasks = await _getAllDbTasks();
    return allTasks.where((task) => task.userId == user.id).toList();
  }

  Future<void> deleteAllTasks() async {
    final db = _getDatabaseOrThrow();

    final deletedCount = await db.delete(taskTable);

    if (deletedCount <= 0) throw CouldNotDeleteTask();
  }

  Future<DatabaseTask> updateTask({
    required DatabaseTask task,
    required String text,
  }) async {
    final db = _getDatabaseOrThrow();

    await getDbTask(id: task.id);

    final updateCount = await db.update(taskTable, {
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });

    if (updateCount != 1) throw CouldNotUpdateTask();

    return task;
  }

  Future<DatabaseUser> getNullUser() async {
    if (_db == null) throw DatabaseIsNotOpened();

    return await getUser(email: notLoggedInUserEmail);
  }

  void setCurrentUser(DatabaseUser user) =>
      _db != null ? _currentUser = user : throw DatabaseIsNotOpened();

  DatabaseUser get currentUser =>
      _db != null ? _currentUser! : throw DatabaseIsNotOpened();

  bool get initialized => _db != null;
}
import 'package:stoodee/services/auth/auth_service.dart';
import 'package:stoodee/services/local_crud/crud_exceptions.dart';
import 'package:stoodee/services/local_crud/local_database_service/consts.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
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

    final String email =
        AuthService.firebase().currentUser?.email ?? defaultNullUserEmail;

    _currentUser = await createOrLoginUser(email: email);
  }

  //Current user is set to nullUser before logging in.
  Future<void> initNullUser() async {
    DatabaseUser? nullUser = await getUserOrNull(email: defaultNullUserEmail);
    nullUser ??= await createUser(email: defaultNullUserEmail);
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

  Future<DatabaseUser> createUser({
    required String email,
  }) async {
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
      name: defaultUserName,
      lastSynced: parseStringToDateTime(defaultDateStr),
      lastStudied: parseStringToDateTime(defaultDateStr),
      dailyGoalFlashcards: defaultDailyFlashcardsGoal,
      dailyGoalTasks: defaultDailyTaskGoal,
      tasksCompletedToday: 0,
      flashcardsCompletedToday: 0,
    );
  }

  Future<DatabaseUser> createOrLoginUser({required String email}) async {
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
    });

    final task = DatabaseTask(
      id: taskId,
      userId: owner.id,
      text: text,
    );

    return task;
  }

  Future<void> deleteTask({required DatabaseTask task}) async {
    final db = _getDatabaseOrThrow();

    final deletedCount = await db.delete(
      taskTable,
      where: 'id = ?',
      whereArgs: [task.id],
    );

    if (deletedCount != 1) throw CouldNotDeleteTask();
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

    final updateCount = await db.update(taskTable, {
      textColumn: text,
    });

    if (updateCount != 1) throw CouldNotUpdateTask();

    return task;
  }

  Future<DatabaseUser> getNullUser() async {
    if (_db == null) throw DatabaseIsNotOpened();

    return await getUser(email: defaultNullUserEmail);
  }

  void setCurrentUser(DatabaseUser user) =>
      _db != null ? _currentUser = user : throw DatabaseIsNotOpened();

  Future<List<DatabaseFlashcardSet>> getUserFlashcardSets(
      {required DatabaseUser user}) async {
    List<DatabaseFlashcardSet> allFcSets = await _getAllDbFlashCardSets();
    return allFcSets.where((fcSet) => fcSet.userId == user.id).toList();
  }

  Future<List<DatabaseFlashcard>> getFlashcardsFromSet(
      {required DatabaseFlashcardSet fcSet}) async {
    List<DatabaseFlashcard> allFlashcards = await _getAllDbFlashcards();
    return allFlashcards
        .where((flashcard) => flashcard.flashcardSetId == fcSet.id)
        .toList();
  }

  Future<DatabaseFlashcardSet> createFcSet({
    required DatabaseUser owner,
    required String name,
  }) async {
    print('i was here c');
    final db = _getDatabaseOrThrow();

    //make sure owner exists in database and isn't hard-coded
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) throw CouldNotFindUser();

    final fcSetId = await db.insert(flashcardSetTable, {
      userIdColumn: owner.id,
      nameColumn: name,
    });

    final fcSet = DatabaseFlashcardSet(
        id: fcSetId, userId: owner.id, name: name, pairCount: 0);

    return fcSet;
  }

  Future<List<DatabaseFlashcardSet>> _getAllDbFlashCardSets() async {
    final db = _getDatabaseOrThrow();

    final flashcardSets = await db.query(flashcardSetTable);

    return flashcardSets
        .map((flashcardSetRow) => DatabaseFlashcardSet.fromRow(flashcardSetRow))
        .toList();
  }

  Future<List<DatabaseFlashcard>> _getAllDbFlashcards() async {
    final db = _getDatabaseOrThrow();

    final flashcards = await db.query(flashcardTable);

    return flashcards
        .map((flashcardRow) => DatabaseFlashcard.fromRow(flashcardRow))
        .toList();
  }

  Future<void> deleteFcSet({required DatabaseFlashcardSet fcSet}) async {
    final db = _getDatabaseOrThrow();

    final deletedCount = await db.delete(
      flashcardSetTable,
      where: 'id = ?',
      whereArgs: [fcSet.id],
    );

    if (deletedCount != 1) throw CouldNotDeleteFcSet();
  }

  Future<DatabaseFlashcardSet> updateFcSet({
    required DatabaseFlashcardSet fcSet,
    required String name,
  }) async {
    final db = _getDatabaseOrThrow();

    final updateCount = await db.update(flashcardSetTable, {
      nameColumn: name,
    });

    if (updateCount != 1) throw CouldNotUpdateFcSet();

    return fcSet;
  }

  Future<DatabaseFlashcard> updateFlashcard({
    required DatabaseFlashcard flashcard,
    required String frontText,
    required String backText,
  }) async {
    final db = _getDatabaseOrThrow();

    final updateCount = await db.update(flashcardTable, {
      frontTextColumn: frontText,
      backTextColumn: backText,
    });

    if (updateCount != 1) throw CouldNotUpdateFlashCard();

    return flashcard;
  }

  Future<DatabaseFlashcardSet> getFcSet({required int id}) async {
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      flashcardSetTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isEmpty) throw CouldNotFindFcSet();

    return DatabaseFlashcardSet.fromRow(results.first);
  }

  Future<DatabaseFlashcard> createFlashcard({
    required DatabaseFlashcardSet fcSet,
    required String frontText,
    required String backText,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure set exists in database and isn't hard-coded
    final ownerSet = await getFcSet(id: fcSet.id);
    if (ownerSet != fcSet) throw CouldNotFindFcSet();

    final flashcardID = await db.insert(flashcardTable, {
      flashcardSetIdColumn: fcSet.id,
      backTextColumn: backText,
      frontTextColumn: frontText,
    });

    fcSet.setPairCount(fcSet.pairCount + 1);

    await db.update(
      flashcardSetTable,
      where: 'id = ?',
      whereArgs: [fcSet.id],
      {
        pairCountColumn: fcSet.pairCount,
      },
    );

    final flashcard = DatabaseFlashcard(
      id: flashcardID,
      flashcardSetId: fcSet.id,
      backText: backText,
      frontText: frontText,
      cardDifficulty: defaultFlashcardDifficulty,
      displayAfterDate: parseStringToDateTime(defaultDateStr),
    );

    return flashcard;
  }

  Future<void> deleteFlashcard({required DatabaseFlashcard flashcard}) async {
    final db = _getDatabaseOrThrow();

    final deletedCount = await db.delete(
      flashcardTable,
      where: 'id = ?',
      whereArgs: [flashcard.id],
    );

    if (deletedCount != 1) throw CouldNotDeleteFlashCard();
  }

  DatabaseUser get currentUser =>
      _db != null ? _currentUser! : throw DatabaseIsNotOpened();

  bool get initialized => _db != null;
}

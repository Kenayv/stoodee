import 'dart:developer';

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

    _currentUser = await loginOrCreateUser(email: email);

    await initAndSetUserStreak(user: _currentUser!);
  }

  //FIXME: split it into 2 methods. one for streak one for tasks and fcs
  Future<void> initAndSetUserStreak({required DatabaseUser user}) async {
    var ___debugInt___ = 0;

    //Resets user's Fcs and tasks completed today to 0 if user hadn't studied today.
    if (daysDifferenceFromNow(user.lastStudied) <= -1) {
      final db = _getDatabaseOrThrow();

      final updateCount = await db.update(
        userTable,
        {
          tasksCompletedTodayColumn: 0,
          flashcardsCompletedTodayColumn: 0,
        },
        where: '$idColumn = ?',
        whereArgs: [user.id],
      );

      ___debugInt___ += updateCount;
      if (updateCount != 1) throw CouldNotUpdateTask();
    }

    //Resets user's streak if user hadn't finished a daily goal for more than 1 day
    if (daysDifferenceFromNow(user.lastStreakBroken) <= -2) {
      final db = _getDatabaseOrThrow();

      final updateCount = await db.update(
        userTable,
        {dayStreakColumn: 0},
        where: '$idColumn = ?',
        whereArgs: [user.id],
      );

      ___debugInt___ += updateCount;
      if (updateCount != 1) throw CouldNotUpdateTask();
    }

    String resetLog =
        "[START] RESET LOG [START]\n\nReseted(OR NOT) user's streak data from:\n[dayStreak: ${user.dayStreak}, FcsToday: ${user.flashcardsCompletedToday}, TasksToday: ${user.tasksCompletedToday},]\nto\n";
    //reload user's data
    user = await getUser(email: user.email);

    resetLog +=
        "[dayStreak: ${user.dayStreak}, FcsToday: ${user.flashcardsCompletedToday}, TasksToday: ${user.tasksCompletedToday},]\n\n with updatesCount: $___debugInt___\n\n[END] RESET LOG [END]";

    log(resetLog);
  }

  //Current user is set to nullUser before logging in.
  Future<void> initNullUser() async {
    DatabaseUser? nullUser = await getUserOrNull(email: defaultNullUserEmail);

    if (nullUser == null) {
      nullUser = await createUser(email: defaultNullUserEmail);
      await setUserName(
        user: nullUser,
        name: "Not Logged In!",
      );
    }
  }

  Future<void> _updateUserStreakAfterChange(
      {required DatabaseUser user}) async {
    final db = _getDatabaseOrThrow();

    if (daysDifferenceFromNow(user.lastStudied) != 0) {
      user.setLastStudied(DateTime.now());
    }

    if (daysDifferenceFromNow(user.lastStreakBroken) != 0 &&
        user.flashcardsCompletedToday >= user.dailyGoalFlashcards &&
        user.tasksCompletedToday >= user.dailyGoalTasks) {
      final updateCount = await db.update(
        userTable,
        {
          lastStreakBrokenColumn: getCurrentDateAsFormattedString(),
          dayStreakColumn: user.dayStreak + 1,
        },
        where: 'id = ?',
        whereArgs: [user.id],
      );

      if (updateCount != 1) throw CouldNotUpdateUser();

      user.setDayStreak(user.dayStreak + 1);
      user.setLastStreakBroken(DateTime.now());
    }
  }

  Future<void> incrFcsCompletedToday({
    required DatabaseUser user,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure owner exists in database and isn't hard-coded
    final dbUser = await getUser(email: user.email);
    if (dbUser != user) throw CouldNotFindUser();

    final newCompletedCount = user.flashcardsCompletedToday + 1;

    final updatesCount = await db.update(
      userTable,
      {
        flashcardsCompletedTodayColumn: newCompletedCount,
      },
      where: '$idColumn = ?',
      whereArgs: [user.id],
    );

    if (updatesCount != 1) throw CouldnotUpdateDailyGoal();

    user.setFcCompletedToday(newCompletedCount);
    await _updateUserStreakAfterChange(user: user);
  }

  Future<void> incrTasksCompletedToday({
    required DatabaseUser user,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure owner exists in database and isn't hard-coded
    final dbUser = await getUser(email: user.email);
    if (dbUser != user) throw CouldNotFindUser();

    final newCompletedCount = user.tasksCompletedToday + 1;

    final updatesCount = await db.update(
      userTable,
      {
        tasksCompletedTodayColumn: newCompletedCount,
      },
      where: '$idColumn = ?',
      whereArgs: [user.id],
    );

    if (updatesCount != 1) throw CouldnotUpdateDailyGoal();

    user.setTasksCompletedToday(newCompletedCount);

    if (daysDifferenceFromNow(user.lastStudied) != 0) {
      user.setLastStudied(DateTime.now());
    }
    await _updateUserStreakAfterChange(user: user);
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
      where: '$emailColumn = ?',
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
      where: '$emailColumn = ?',
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
      lastStreakBroken: parseStringToDateTime(defaultDateStr),
      lastStudied: parseStringToDateTime(defaultDateStr),
      dailyGoalFlashcards: defaultDailyFlashcardsGoal,
      dailyGoalTasks: defaultDailyTaskGoal,
      tasksCompletedToday: 0,
      flashcardsCompletedToday: 0,
      dayStreak: 0,
    );
  }

  Future<DatabaseUser> loginOrCreateUser({required String email}) async {
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
      where: '$emailColumn = ?',
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

    //make sure task exists in database and isn't hard-coded
    final dbTask = await getTask(id: task.id);
    if (dbTask != task) throw CouldNotFindTask();

    final deletedCount = await db.delete(
      taskTable,
      where: '$idColumn = ?',
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

    //make sure task exists in database and isn't hard-coded
    final dbTask = await getTask(id: task.id);
    if (dbTask != task) throw CouldNotFindTask();

    final updateCount = await db.update(
      taskTable,
      {
        textColumn: text,
      },
      where: '$idColumn = ?',
      whereArgs: [task.id],
    );

    if (updateCount != 1) throw CouldNotUpdateTask();

    return task;
  }

  Future<DatabaseUser> getNullUser() async {
    return await getUser(email: defaultNullUserEmail);
  }

  Future<void> setCurrentUser(DatabaseUser user) async {
    if (_db == null) throw DatabaseIsNotOpened();

    //Make sure the user exists and isn't hard-coded
    final dbUser = await getUser(email: user.email);
    if (dbUser != user) throw CouldNotFindUser();

    _currentUser = dbUser;
  }

  Future<List<DatabaseFlashcardSet>> getUserFlashcardSets({
    required DatabaseUser user,
  }) async {
    List<DatabaseFlashcardSet> allFcSets = await _getAllDbFlashCardSets();
    return allFcSets.where((fcSet) => fcSet.userId == user.id).toList();
  }

  Future<List<DatabaseFlashcard>> getFlashcardsFromSet({
    required DatabaseFlashcardSet fcSet,
  }) async {
    List<DatabaseFlashcard> allFlashcards = await _getAllDbFlashcards();
    return allFlashcards
        .where((flashcard) => flashcard.flashcardSetId == fcSet.id)
        .toList();
  }

  Future<DatabaseFlashcardSet> createFcSet({
    required DatabaseUser owner,
    required String name,
  }) async {
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
      where: '$idColumn = ?',
      whereArgs: [fcSet.id],
    );

    if (deletedCount != 1) throw CouldNotDeleteFcSet();
  }

  Future<DatabaseFlashcardSet> updateFcSet({
    required DatabaseFlashcardSet fcSet,
    required String name,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure fcSet exists in database and isn't hard-coded
    final dbFcSet = await getFcSet(id: fcSet.id);
    if (dbFcSet != fcSet) throw CouldNotFindTask();

    final updateCount = await db.update(
      flashcardSetTable,
      {
        nameColumn: name,
      },
      where: '$idColumn = ?',
      whereArgs: [fcSet.id],
    );

    if (updateCount != 1) throw CouldNotUpdateFcSet();

    return fcSet;
  }

  Future<DatabaseFlashcard> updateFlashcard({
    required DatabaseFlashcard flashcard,
    required String frontText,
    required String backText,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure flashcard exists in database and isn't hard-coded
    final dbFlashcard = await getFlashcard(id: flashcard.id);
    if (dbFlashcard != flashcard) throw CouldNotFindFlashCard();

    final updateCount = await db.update(
      flashcardTable,
      {
        frontTextColumn: frontText,
        backTextColumn: backText,
      },
      where: '$idColumn = ?',
      whereArgs: [flashcard.id],
    );

    if (updateCount != 1) throw CouldNotUpdateFlashCard();

    return flashcard;
  }

  Future<DatabaseFlashcardSet> getFcSet({required int id}) async {
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      flashcardSetTable,
      limit: 1,
      where: '$idColumn = ?',
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
      where: '$idColumn = ?',
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
      where: '$idColumn = ?',
      whereArgs: [flashcard.id],
    );

    if (deletedCount != 1) throw CouldNotDeleteFlashCard();
  }

  Future<DatabaseFlashcard> getFlashcard({required int id}) async {
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      flashcardTable,
      limit: 1,
      where: '$idColumn = ?',
      whereArgs: [id],
    );

    if (results.isEmpty) throw CouldNotFindFcSet();

    return DatabaseFlashcard.fromRow(results.first);
  }

  Future<DatabaseTask> getTask({required int id}) async {
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      taskTable,
      limit: 1,
      where: '$idColumn = ?',
      whereArgs: [id],
    );

    if (results.isEmpty) throw CouldNotFindFcSet();

    return DatabaseTask.fromRow(results.first);
  }

  Future<void> setUserName({
    required DatabaseUser user,
    required String name,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure user exists in database and isn't hard-coded
    final dbUser = await getUser(email: user.email);
    if (dbUser != user) throw CouldNotFindUser();

    final updateCount = await db.update(
      userTable,
      {
        nameColumn: name,
      },
      where: '$idColumn = ?',
      whereArgs: [user.id],
    );

    user.setName(name);

    if (updateCount != 1) throw CouldNotUpdateUser();
  }

  Future<void> setUserDailyTaskGoal({
    required DatabaseUser user,
    required int taskGoal,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure user exists in database and isn't hard-coded
    final dbUser = await getUser(email: user.email);
    if (dbUser != user) throw CouldNotFindUser();

    final updateCount = await db.update(
      userTable,
      {
        dailyGoalTasksColumn: taskGoal,
      },
      where: '$idColumn = ?',
      whereArgs: [user.id],
    );

    user.setDailyTaskGoal(taskGoal);

    if (updateCount != 1) throw CouldNotUpdateUser();
  }

  Future<void> setUserDailyFlashcardGoal({
    required DatabaseUser user,
    required int flashcardGoal,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure user exists in database and isn't hard-coded
    final dbUser = await getUser(email: user.email);
    if (dbUser != user) throw CouldNotFindUser();

    final updateCount = await db.update(
      userTable,
      {
        dailyGoalFlashcardsColumn: flashcardGoal,
      },
      where: '$idColumn = ?',
      whereArgs: [user.id],
    );

    user.setDailyFlashcardsGoal(flashcardGoal);

    if (updateCount != 1) throw CouldNotUpdateUser();
  }

  DatabaseUser get currentUser =>
      initialized ? _currentUser! : throw DatabaseIsNotOpened();

  bool get initialized => _db != null && _currentUser != null;
}

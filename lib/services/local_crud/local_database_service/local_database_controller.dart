import 'dart:developer';
import 'package:stoodee/services/auth/auth_service.dart';
import 'package:stoodee/services/cloud_crud/cloud_database_controller.dart';
import 'package:stoodee/services/flashcards/flashcard_service.dart';
import 'package:stoodee/services/local_crud/crud_exceptions.dart';
import 'package:stoodee/services/local_crud/local_database_service/consts.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_task.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:stoodee/services/todoTasks/todo_service.dart';

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
    var totalUpdatesCount = 0;

    //Resets user's Fcs and tasks completed today to 0 if user hadn't studied today.
    if (daysDifferenceFromNow(user.lastStudied) <= -1) {
      final db = _getDatabaseOrThrow();

      final updateCount = await db.update(
        userTable,
        {
          tasksCompletedTodayColumn: 0,
          flashcardsCompletedTodayColumn: 0,
        },
        where: '$localIdColumn = ?',
        whereArgs: [user.id],
      );

      totalUpdatesCount += updateCount;
      if (updateCount != 1) throw CouldNotUpdateTask();
    }

    //Resets user's streak if user hadn't finished a daily goal for more than 1 day
    if (daysDifferenceFromNow(user.lastStreakBroken) <= -2) {
      final db = _getDatabaseOrThrow();

      final updateCount = await db.update(
        userTable,
        {currentDayStreakColumn: 0},
        where: '$localIdColumn = ?',
        whereArgs: [user.id],
      );

      totalUpdatesCount += updateCount;
      if (updateCount != 1) throw CouldNotUpdateTask();
    }

    if (totalUpdatesCount > 0) await reloadCurrentUser();
  }

  Future<void> reloadCurrentUser() async {
    if (_currentUser == null) throw UserNotFound();

    _currentUser = await getUserByEmail(email: _currentUser!.email);
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

  Future<void> _updateUserStreakAfterChange({
    required DatabaseUser user,
  }) async {
    final db = _getDatabaseOrThrow();

    if (daysDifferenceFromNow(user.lastStudied) == 0) {
      _setUserLastStudied(user: user, lastStudied: DateTime.now());
    }

    if (daysDifferenceFromNow(user.lastStreakBroken) != 0 &&
        user.flashcardsCompletedToday >= user.dailyGoalFlashcards &&
        user.tasksCompletedToday >= user.dailyGoalTasks) {
      final newDayStreak = user.currentDayStreak + 1;
      int userStreakHighscore = user.streakHighscore;

      if (newDayStreak >= userStreakHighscore) {
        userStreakHighscore = newDayStreak;
      }

      final updateCount = await db.update(
        userTable,
        {
          lastStreakBrokenColumn: getCurrentDateAsFormattedString(),
          currentDayStreakColumn: newDayStreak,
          streakHighscoreColumn: userStreakHighscore,
        },
        where: 'id = ?',
        whereArgs: [user.id],
      );

      if (updateCount != 1) throw CouldNotUpdateUser();

      user.setCurrentDayStreak(user.currentDayStreak + 1);
      if (userStreakHighscore == newDayStreak) {
        user.setStreakHighscore(userStreakHighscore);
      }
      user.setLastStreakBroken(DateTime.now());
    }
  }

  Future<void> incrFcsCompleted({
    required DatabaseUser user,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure owner exists in database and isn't hard-coded
    final dbUser = await getUserByEmail(email: user.email);
    if (dbUser != user) throw CouldNotFindUser();

    final newTotalCompletedCount = user.totalFlashcardsCompleted + 1;
    final newFlashcardsCompletedToday = user.flashcardsCompletedToday + 1;

    final updatesCount = await db.update(
      userTable,
      {
        totalFlashcardsCompletedColumn: newTotalCompletedCount,
        flashcardsCompletedTodayColumn: newFlashcardsCompletedToday,
        lastStudiedColumn: getCurrentDateAsFormattedString(),
      },
      where: '$localIdColumn = ?',
      whereArgs: [user.id],
    );

    if (updatesCount != 1) throw CouldnotUpdateDailyGoal();

    user.setTotalFcsCompleted(newTotalCompletedCount);
    user.setFcCompletedToday(newFlashcardsCompletedToday);

    await _updateUserStreakAfterChange(user: user);
    await _setUserLastChangesNow(user: user);
  }

  Future<void> incrTasksCompleted({
    required DatabaseUser user,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure owner exists in database and isn't hard-coded
    final dbUser = await getUserByEmail(email: user.email);
    if (dbUser != user) throw CouldNotFindUser();

    final newTotalCompletedCount = user.totalTasksCompleted + 1;
    final newTasksCompletedToday = user.tasksCompletedToday + 1;

    final updatesCount = await db.update(
      userTable,
      {
        totalTasksCompletedColumn: newTotalCompletedCount,
        tasksCompletedTodayColumn: newTasksCompletedToday,
        lastStudiedColumn: getCurrentDateAsFormattedString(),
      },
      where: '$localIdColumn = ?',
      whereArgs: [user.id],
    );

    if (updatesCount != 1) throw CouldnotUpdateDailyGoal();

    user.setTotalTasksCompleted(newTotalCompletedCount);
    user.setTasksCompletedToday(newTasksCompletedToday);

    user.setLastStudied(DateTime.now());
    await _updateUserStreakAfterChange(user: user);
    await _setUserLastChangesNow(user: user);
  }

  Future<void> incrIncompleteTasks({
    required DatabaseUser user,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure owner exists in database and isn't hard-coded
    final dbUser = await getUserByEmail(email: user.email);
    if (dbUser != user) throw CouldNotFindUser();

    final newIncompleteTasksCount = user.totalIncompleteTasks + 1;

    final updatesCount = await db.update(
      userTable,
      {
        totalIncompleteTasksColumn: newIncompleteTasksCount,
        lastStudiedColumn: getCurrentDateAsFormattedString(),
      },
      where: '$localIdColumn = ?',
      whereArgs: [user.id],
    );

    if (updatesCount != 1) throw CouldnotUpdateDailyGoal();

    user.setTotalIncompleteTasks(newIncompleteTasksCount);
    user.setLastStudied(DateTime.now());
    await _setUserLastChangesNow(user: user);
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
      rethrow;
    } catch (e) {
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

  Future<void> deleteUser({required DatabaseUser user}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: '$emailColumn = ?',
      whereArgs: [user.email.toLowerCase()],
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
    final newUser = DatabaseUser(
      id: userId,
      cloudId: null,
      email: email,
      name: defaultUserName,
      lastSynced: parseStringToDateTime(defaultDateStr),
      lastChanges: parseStringToDateTime(defaultDateStr),
      lastStreakBroken: parseStringToDateTime(defaultDateStr),
      lastStudied: parseStringToDateTime(defaultDateStr),
      dailyGoalFlashcards: defaultDailyFlashcardsGoal,
      dailyGoalTasks: defaultDailyTaskGoal,
      tasksCompletedToday: 0,
      flashcardsCompletedToday: 0,
      currentDayStreak: 0,
      totalFlashcardsCompleted: 0,
      totalTasksCompleted: 0,
      streakHighscore: 0,
      totalIncompleteTasks: 0,
      flashcardRushHighscore: 0,
    );
    return newUser;
  }

  Future<DatabaseUser> loginOrCreateUser({required String email}) async {
    DatabaseUser? user = await getUserOrNull(email: email);

    user ??= await createUser(email: email);
    setCurrentUser(user);

    return user;
  }

  Future<DatabaseUser> getUserByEmail({required String email}) async {
    final DatabaseUser? user = await getUserOrNull(email: email);

    if (user == null) throw CouldNotFindUser();

    return user;
  }

  Future<DatabaseUser> getUserById({required int id}) async {
    final db = _getDatabaseOrThrow();

    final result = await db.query(
      userTable,
      limit: 1,
      where: '$localIdColumn = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) throw CouldNotFindUser();

    return DatabaseUser.fromRow(result.first);
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

  Future<void> setUserCloudId({
    required DatabaseUser user,
    required String cloudId,
  }) async {
    final db = _getDatabaseOrThrow();

    final dbUser = await getUserByEmail(email: user.email);
    if (dbUser != user) throw CouldNotFindUser();

    if (user.cloudId != null) throw UserCloudIdAlreadyInitialized();

    final updatesCount = await db.update(
      userTable,
      {cloudIdColumn: cloudId},
      where: '$localIdColumn = ?',
      whereArgs: [user.id],
    );

    if (updatesCount != 1) throw CouldNotUpdateUser();
    await _setUserLastChangesNow(user: user);
  }

  Future<DatabaseUser> _setUserLastChangesNow({
    required DatabaseUser user,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure task exists in database and isn't hard-coded
    final dbUser = await getUserByEmail(email: user.email);
    if (dbUser != user) throw CouldNotFindUser();

    final now = DateTime.now();

    final updateCount = await db.update(
      userTable,
      {
        lastChangesColumn: getDateAsFormattedString(now),
      },
      where: '$localIdColumn = ?',
      whereArgs: [user.id],
    );

    if (updateCount != 1) throw CouldNotUpdateTask();

    user.setLastChanges(now);

    return user;
  }

  Future<DatabaseUser> _setUserLastStudied({
    required DatabaseUser user,
    required DateTime lastStudied,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure task exists in database and isn't hard-coded
    final dbUser = await getUserByEmail(email: user.email);
    if (dbUser != user) throw CouldNotFindUser();

    final updateCount = await db.update(
      userTable,
      {
        lastStudiedColumn: getDateAsFormattedString(lastStudied),
      },
      where: '$localIdColumn = ?',
      whereArgs: [user.id],
    );

    if (updateCount != 1) throw CouldNotUpdateTask();

    user.setLastStudied(lastStudied);
    await _setUserLastChangesNow(user: user);

    return user;
  }

  Future<DatabaseTask> createTask({
    required DatabaseUser user,
    required String text,
  }) async {
    final db = _getDatabaseOrThrow();

    final taskId = await db.insert(taskTable, {
      userIdColumn: user.id,
      textColumn: text,
    });

    final task = DatabaseTask(
      id: taskId,
      userId: user.id,
      text: text,
    );

    await _setUserLastChangesNow(user: user);

    return task;
  }

  Future<void> deleteTask({
    required DatabaseTask task,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure task exists in database and isn't hard-coded
    final dbTask = await getTask(id: task.id);
    if (dbTask != task) throw CouldNotFindTask();

    final deletedCount = await db.delete(
      taskTable,
      where: '$localIdColumn = ?',
      whereArgs: [task.id],
    );

    if (deletedCount != 1) throw CouldNotDeleteTask();

    final owner = await getUserById(id: task.userId);
    await _setUserLastChangesNow(user: owner);
  }

  Future<List<DatabaseTask>> _getAllDbTasks() async {
    final db = _getDatabaseOrThrow();
    final tasks = await db.query(taskTable);

    return tasks.map((taskRow) => DatabaseTask.fromRow(taskRow)).toList();
  }

  Future<List<DatabaseTask>> getUserTasks({
    required DatabaseUser user,
  }) async {
    List<DatabaseTask> allTasks = await _getAllDbTasks();
    return allTasks.where((task) => task.userId == user.id).toList();
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
      where: '$localIdColumn = ?',
      whereArgs: [task.id],
    );

    if (updateCount != 1) throw CouldNotUpdateTask();

    final owner = await getUserById(id: task.userId);
    await _setUserLastChangesNow(user: owner);

    return task;
  }

  Future<void> updateUserFcRushHighscore({
    required DatabaseUser user,
    required int value,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure user exists in database and isn't hard-coded
    final dbUser = await getUserByEmail(email: user.email);
    if (dbUser != user) throw CouldNotFindTask();

    final updateCount = await db.update(
      userTable,
      {
        flashcardRushHighscoreColumn: value,
      },
      where: '$localIdColumn = ?',
      whereArgs: [user.id],
    );

    if (updateCount != 1) throw CouldNotUpdateTask();

    user.setFlashcardRushHighscore(value);
    await _setUserLastChangesNow(user: user);
  }

  Future<DatabaseUser> getNullUser() async {
    return await getUserByEmail(email: defaultNullUserEmail);
  }

  Future<void> setCurrentUser(DatabaseUser user) async {
    if (_db == null) throw DatabaseIsNotOpened();

    //Make sure the user exists and isn't hard-coded
    final dbUser = await getUserByEmail(email: user.email);
    if (dbUser != user) throw CouldNotFindUser();

    _currentUser = dbUser;
  }

  Future<List<DatabaseFlashcardSet>> getUserFlashcardSets({
    required DatabaseUser user,
  }) async {
    List<DatabaseFlashcardSet> allFcSets = await _getAllDbFlashCardSets();
    return allFcSets.where((fcSet) => fcSet.userId == user.id).toList();
  }

  Future<List<DatabaseFlashcard>> getUserFlashcards({
    required DatabaseUser user,
  }) async {
    List<DatabaseFlashcard> flashcards = await _getAllDbFlashcards();

    return flashcards
        .where((flashcard) => flashcard.userId == user.id)
        .toList();
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
    final dbUser = await getUserByEmail(email: owner.email);
    if (dbUser != owner) throw CouldNotFindUser();

    final fcSetId = await db.insert(flashcardSetTable, {
      userIdColumn: owner.id,
      nameColumn: name,
    });

    final fcSet = DatabaseFlashcardSet(
      id: fcSetId,
      userId: owner.id,
      name: name,
      pairCount: 0,
    );

    await _setUserLastChangesNow(user: owner);

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
      where: '$localIdColumn = ?',
      whereArgs: [fcSet.id],
    );

    if (deletedCount != 1) throw CouldNotDeleteFcSet();

    if (fcSet.pairCount > 0) {
      await _deleteFlashcardsBySetId(fcSetId: fcSet.id);
    }

    final owner = await getUserById(id: fcSet.userId);
    await _setUserLastChangesNow(user: owner);
  }

  Future<void> _deleteFlashcardsBySetId({required int fcSetId}) async {
    final db = _getDatabaseOrThrow();

    final deletedCount = await db.delete(
      flashcardTable,
      where: '$flashcardSetIdColumn = ?',
      whereArgs: [fcSetId],
    );

    if (deletedCount == 0) throw CouldNotDeleteFlashcard();
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
      where: '$localIdColumn = ?',
      whereArgs: [fcSet.id],
    );

    if (updateCount != 1) throw CouldNotUpdateFcSet();

    final user = await getUserById(id: fcSet.userId);
    await _setUserLastChangesNow(user: user);

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
      where: '$localIdColumn = ?',
      whereArgs: [flashcard.id],
    );

    if (updateCount != 1) throw CouldNotUpdateFlashCard();

    final user = await getUserById(id: flashcard.userId);
    await _setUserLastChangesNow(user: user);

    return flashcard;
  }

  Future<DatabaseFlashcardSet> getFcSet({required int id}) async {
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      flashcardSetTable,
      limit: 1,
      where: '$localIdColumn = ?',
      whereArgs: [id],
    );

    if (results.isEmpty) throw CouldNotFindFcSet();

    return DatabaseFlashcardSet.fromRow(results.first);
  }

  Future<void> setFcdifficulty({
    required DatabaseFlashcard flashcard,
    required int difficulty,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure flashcard exists in database and isn't hard-coded
    final dbFlashcard = await getFlashcard(id: flashcard.id);
    if (dbFlashcard != flashcard) throw CouldNotFindFlashCard();

    final updateCount = await db.update(
      flashcardTable,
      {cardDifficultyColumn: difficulty},
      where: '$localIdColumn = ?',
      whereArgs: [flashcard.id],
    );

    final user = await getUserById(id: flashcard.userId);
    await _setUserLastChangesNow(user: user);

    if (updateCount != 1) throw CouldNotUpdateFlashCard();
  }

  Future<void> setFcDisplayDate({
    required DatabaseFlashcard flashcard,
    required DateTime displayDate,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure flashcard exists in database and isn't hard-coded
    final dbFlashcard = await getFlashcard(id: flashcard.id);
    if (dbFlashcard != flashcard) throw CouldNotFindFlashCard();

    final updateCount = await db.update(
      flashcardTable,
      {displayDateColumn: getDateAsFormattedString(displayDate)},
      where: '$localIdColumn = ?',
      whereArgs: [flashcard.id],
    );

    final user = await getUserById(id: flashcard.userId);
    await _setUserLastChangesNow(user: user);

    if (updateCount != 1) throw CouldNotUpdateFlashCard();
  }

  Future<DatabaseFlashcard> createFlashcard({
    required DatabaseUser user,
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
      userIdColumn: user.id,
      backTextColumn: backText,
      frontTextColumn: frontText,
    });

    fcSet.setPairCount(fcSet.pairCount + 1);

    await db.update(
      flashcardSetTable,
      where: '$localIdColumn = ?',
      whereArgs: [fcSet.id],
      {
        pairCountColumn: fcSet.pairCount,
      },
    );

    final flashcard = DatabaseFlashcard(
      id: flashcardID,
      flashcardSetId: fcSet.id,
      userId: user.id,
      backText: backText,
      frontText: frontText,
      cardDifficulty: defaultFlashcardDifficulty,
      displayDate: parseStringToDateTime(defaultDateStr),
    );

    await _setUserLastChangesNow(user: user);
    return flashcard;
  }

  Future<void> deleteFlashcard({required DatabaseFlashcard flashcard}) async {
    final db = _getDatabaseOrThrow();
    final fcSet = await getFlashcardSet(id: flashcard.flashcardSetId);

    final deletedCount = await db.delete(
      flashcardTable,
      where: '$localIdColumn = ?',
      whereArgs: [flashcard.id],
    );

    final updateCount = await db.update(
      flashcardSetTable,
      where: '$localIdColumn = ?',
      {
        pairCountColumn: fcSet.pairCount - 1,
      },
      whereArgs: [fcSet.id],
    );

    if (deletedCount != 1) throw CouldNotFindFlashCard();
    if (updateCount != 1) throw CouldNotFindFcSet();

    final user = await getUserById(id: flashcard.userId);
    await _setUserLastChangesNow(user: user);
  }

  Future<DatabaseFlashcard> getFlashcard({required int id}) async {
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      flashcardTable,
      limit: 1,
      where: '$localIdColumn = ?',
      whereArgs: [id],
    );

    if (results.isEmpty) throw CouldNotFindFcSet();

    return DatabaseFlashcard.fromRow(results.first);
  }

  Future<DatabaseFlashcardSet> getFlashcardSet({required int id}) async {
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      flashcardSetTable,
      limit: 1,
      where: '$localIdColumn = ?',
      whereArgs: [id],
    );

    if (results.isEmpty) throw CouldNotFindFcSet();

    return DatabaseFlashcardSet.fromRow(results.first);
  }

  Future<DatabaseTask> getTask({required int id}) async {
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      taskTable,
      limit: 1,
      where: '$localIdColumn = ?',
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
    final dbUser = await getUserByEmail(email: user.email);
    if (dbUser != user) throw CouldNotFindUser();

    final updateCount = await db.update(
      userTable,
      {
        nameColumn: name,
      },
      where: '$localIdColumn = ?',
      whereArgs: [user.id],
    );

    user.setName(name);

    if (updateCount != 1) throw CouldNotUpdateUser();
    await _setUserLastChangesNow(user: user);
  }

  Future<void> setLastSynced({
    required DatabaseUser user,
    required DateTime date,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure user exists in database and isn't hard-coded
    final dbUser = await getUserByEmail(email: user.email);
    if (dbUser != user) throw CouldNotFindUser();

    final updateCount = await db.update(
      userTable,
      {
        lastSyncedColumn: getDateAsFormattedString(date),
      },
      where: '$localIdColumn = ?',
      whereArgs: [user.id],
    );

    user.setLastSynced(date);

    if (updateCount != 1) throw CouldNotUpdateUser();
  }

  Future<void> setUserDailyTaskGoal({
    required DatabaseUser user,
    required int taskGoal,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure user exists in database and isn't hard-coded
    final dbUser = await getUserByEmail(email: user.email);
    if (dbUser != user) throw CouldNotFindUser();

    final updateCount = await db.update(
      userTable,
      {
        dailyGoalTasksColumn: taskGoal,
      },
      where: '$localIdColumn = ?',
      whereArgs: [user.id],
    );

    user.setDailyTaskGoal(taskGoal);

    if (updateCount != 1) throw CouldNotUpdateUser();
    await _setUserLastChangesNow(user: user);
  }

  Future<void> setUserDailyFlashcardGoal({
    required DatabaseUser user,
    required int flashcardGoal,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure user exists in database and isn't hard-coded
    final dbUser = await getUserByEmail(email: user.email);
    if (dbUser != user) throw CouldNotFindUser();

    final updateCount = await db.update(
      userTable,
      {
        dailyGoalFlashcardsColumn: flashcardGoal,
      },
      where: '$localIdColumn = ?',
      whereArgs: [user.id],
    );

    user.setDailyFlashcardsGoal(flashcardGoal);

    if (updateCount != 1) throw CouldNotUpdateUser();
    await _setUserLastChangesNow(user: user);
  }

  Future<void> syncWithCloud() async {
    log('Syncing with cloud\n');

    var user = currentUser;

    if (user == await LocalDbController().getNullUser()) {
      throw CannotSyncNullUser();
    }

    //throw if user syncs too frequently
    if (DateTime.now().difference(user.lastSynced).inMinutes < 15) {
      throw CannotSyncSoFrequently();
    }

    await setLastSynced(user: user, date: DateTime.now());
    //If userCloudId is null locally but exists in cloud:
    if (user.cloudId == null) {
      //Check if user exists in cloud db. If so, assign an id to them
      final cloudId = await CloudDbController().getUserIdByEmail(
        email: user.email,
      );
      if (cloudId != null) {
        //set id and reload user
        await setUserCloudId(user: user, cloudId: cloudId);
        user = await getUserByEmail(email: user.email);
      }
    }

    final cloudUser =
        await CloudDbController().getUserOrNull(cloudId: user.cloudId);

    //push if user==null or cloud data is outdated
    if (cloudUser == null || cloudUser.lastChanges.isBefore(user.lastChanges)) {
      await _saveAllToCloud(user);
    } else {
      await _loadAllFromCloud(user);
    }
  }

  Future<void> _saveAllToCloud(DatabaseUser user) async {
    log('Saving all to cloud');

    await _setUserLastChangesNow(user: user);
    await _setUserLastStudied(user: user, lastStudied: DateTime.now());
    await CloudDbController().saveAllToCloud(user: user);
  }

  Future<void> _updateUser({
    required DatabaseUser user,
  }) async {
    final db = _getDatabaseOrThrow();

    await db.update(
      userTable,
      user.toJson(),
      where: '$localIdColumn = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> _updateOrCreateFcSet({
    required DatabaseFlashcardSet fcSet,
  }) async {
    final db = _getDatabaseOrThrow();

    int rowsUpdated = await db.update(
      flashcardSetTable,
      fcSet.toJson(),
      where: '$localIdColumn = ?',
      whereArgs: [fcSet.id],
    );

    if (rowsUpdated == 0) {
      await db.insert(
        flashcardSetTable,
        fcSet.toJson(),
      );
    }
  }

  Future<void> _updateOrCreateFlashcard({
    required DatabaseFlashcard flashcard,
  }) async {
    final db = _getDatabaseOrThrow();

    int rowsUpdated = await db.update(
      flashcardTable,
      flashcard.toJson(),
      where: '$localIdColumn = ?',
      whereArgs: [flashcard.id],
    );

    if (rowsUpdated == 0) {
      await db.insert(
        flashcardTable,
        flashcard.toJson(),
      );
    }
  }

  Future<void> _updateOrCreateTask({
    required DatabaseTask task,
  }) async {
    final db = _getDatabaseOrThrow();

    int rowsUpdated = await db.update(
      taskTable,
      task.toJson(),
      where: '$localIdColumn = ?',
      whereArgs: [task.id],
    );

    // If no rows were updated, it means the task doesn't exist, so insert it instead
    if (rowsUpdated == 0) {
      await db.insert(
        taskTable,
        task.toJson(),
      );
    }
  }

  Future<void> _loadAllFromCloud(DatabaseUser user) async {
    final cloudUserData = await CloudDbController().loadAllFromCloud(
      user: user,
    );
    log('loading all from cloud:\n\n');
    log('$cloudUserData\n\n');

    await _updateUser(user: user);

    for (final task in cloudUserData.tasks) {
      await _updateOrCreateTask(task: task);
    }

    for (final fcSet in cloudUserData.flashcardSets) {
      await _updateOrCreateFcSet(fcSet: fcSet);
    }

    for (final flashcard in cloudUserData.flashcards) {
      await _updateOrCreateFlashcard(flashcard: flashcard);
    }

    await reloadCurrentUser();
    await TodoService().reloadTasks();
    await FlashcardsService().reloadFlashcardSets();
  }

  bool isNullUser(DatabaseUser user) => user.email == defaultNullUserEmail;

  DatabaseUser get currentUser =>
      initialized ? _currentUser! : throw DatabaseIsNotOpened();

  bool get initialized => _db != null && _currentUser != null;
}

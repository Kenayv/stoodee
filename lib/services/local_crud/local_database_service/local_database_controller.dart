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
import 'package:stoodee/services/network/network_controller.dart';
import 'package:stoodee/services/todoTasks/todo_service.dart';

class LocalDbController {
  Database? _db;
  User? _currentUser;

  //Database Service should be only used via singleton //
  static final LocalDbController _shared = LocalDbController._sharedInstance();
  factory LocalDbController() => _shared;
  LocalDbController._sharedInstance();
  //Database Service should be only used via singleton //

  //Must be invoked after firebase/firestore init.
  Future<void> init() async {
    await _openDb();
    await _initNullUser();

    final String email =
        AuthService.firebase().currentUser?.email ?? defaultNullUserEmail;

    _currentUser = await loginOrCreateUser(email: email);

    await _initAndSetUserStreak(user: _currentUser!);
  }

  //Logs in if user exists in database. If not, creates new user
  Future<User> loginOrCreateUser({required String email}) async {
    User? user = await getUserOrNull(email: email);

    user ??= await createUser(email: email);
    setCurrentUser(user: user);

    return user;
  }

  Future<void> setCurrentUser({required User user}) async {
    if (_db == null) throw DatabaseIsNotOpened();

    //Make sure the user exists and isn't hard-coded
    final dbUser = await getDbUser(email: user.email);
    if (dbUser != user) throw CouldNotFindUser();

    _currentUser = dbUser;
  }

  Future<User> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();

    final result = await db.query(
      userTable,
      limit: 1,
      where: '$emailColumn = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (result.isNotEmpty) throw UserAlreadyExists();

    await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });

    final newUser = User(
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

  Future<Task> createTask({
    required User user,
    required String text,
  }) async {
    final db = _getDatabaseOrThrow();

    final taskId = await db.insert(taskTable, {
      userEmailColumn: user.email,
      textColumn: text,
    });

    final task = Task(
      id: taskId,
      userEmail: user.email,
      text: text,
    );

    //update user's "last change date" variable for correct syncing with cloud
    await _setUserLastChangesNow(user: user);

    return task;
  }

  Future<FlashcardSet> createFcSet({
    required User owner,
    required String name,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure owner exists in database and isn't hard-coded
    final dbUser = await getDbUser(email: owner.email);
    if (dbUser != owner) throw CouldNotFindUser();

    final fcSetId = await db.insert(
      flashcardSetTable,
      {
        userEmailColumn: owner.email,
        nameColumn: name,
      },
    );

    final fcSet = FlashcardSet(
      id: fcSetId,
      userEmail: owner.email,
      name: name,
      pairCount: 0,
    );

    //update user's "last change date" variable for correct syncing with cloud
    await _setUserLastChangesNow(user: owner);

    return fcSet;
  }

  Future<Flashcard> createFlashcard({
    required User user,
    required FlashcardSet fcSet,
    required String frontText,
    required String backText,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure set exists in database and isn't hard-coded
    final ownerSet = await getFcSet(id: fcSet.id);
    if (ownerSet != fcSet) throw CouldNotFindFcSet();

    final flashcardID = await db.insert(
      flashcardTable,
      {
        flashcardSetIdColumn: fcSet.id,
        userEmailColumn: user.email,
        backTextColumn: backText,
        frontTextColumn: frontText,
      },
    );

    //incr parent set's pairCount variable
    fcSet.setPairCount(fcSet.pairCount + 1);
    await db.update(
      flashcardSetTable,
      where: '$localIdColumn = ?',
      whereArgs: [fcSet.id],
      {
        pairCountColumn: fcSet.pairCount,
      },
    );

    final flashcard = Flashcard(
      id: flashcardID,
      flashcardSetId: fcSet.id,
      userEmail: user.email,
      backText: backText,
      frontText: frontText,
      cardDifficulty: defaultFlashcardDifficulty,
      displayDate: parseStringToDateTime(defaultDateStr),
    );

    //update user's "last change date" variable for correct syncing with cloud
    await _setUserLastChangesNow(user: user);
    return flashcard;
  }

  Future<Task> updateTaskText({
    required Task task,
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

    //update user's "last change date" variable for correct syncing with cloud
    final owner = await getDbUser(email: task.userEmail);
    await _setUserLastChangesNow(user: owner);

    return task;
  }

  Future<void> updateFcdifficulty({
    required Flashcard flashcard,
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

    //update user's "last change date" variable for correct syncing with cloud
    final user = await getDbUser(email: flashcard.userEmail);
    await _setUserLastChangesNow(user: user);

    if (updateCount != 1) throw CouldNotUpdateFlashCard();
  }

  Future<void> updateFcDisplayDate({
    required Flashcard flashcard,
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

    //update user's "last change date" variable for correct syncing with cloud
    final user = await getDbUser(email: flashcard.userEmail);
    await _setUserLastChangesNow(user: user);

    if (updateCount != 1) throw CouldNotUpdateFlashCard();
  }

  // >> Methods for updating user database variables >>
  Future<void> updateUserCloudId({
    required User user,
    required String cloudId,
  }) async {
    final db = _getDatabaseOrThrow();

    final dbUser = await getDbUser(email: user.email);
    if (dbUser != user) throw CouldNotFindUser();

    if (user.cloudId != null) throw UserCloudIdAlreadyInitialized();

    final updatesCount = await db.update(
      userTable,
      {cloudIdColumn: cloudId},
      where: '$emailColumn = ?',
      whereArgs: [user.email],
    );

    //update user's "last change date" variable for correct syncing with cloud
    if (updatesCount != 1) throw CouldNotUpdateUser();
  }

  Future<void> updateUserName({
    required User user,
    required String name,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure user exists in database and isn't hard-coded
    final dbUser = await getDbUser(email: user.email);
    if (dbUser != user) throw CouldNotFindUser();

    final updateCount = await db.update(
      userTable,
      {
        nameColumn: name,
      },
      where: '$emailColumn = ?',
      whereArgs: [user.email],
    );

    if (updateCount != 1) throw CouldNotUpdateUser();

    user.setName(name);

    //update user's "last change date" variable for correct syncing with cloud
    await _setUserLastChangesNow(user: user);
  }

  Future<void> updateUserDailyTaskGoal({
    required User user,
    required int taskGoal,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure user exists in database and isn't hard-coded
    final dbUser = await getDbUser(email: user.email);
    if (dbUser != user) throw CouldNotFindUser();

    final updateCount = await db.update(
      userTable,
      {
        dailyGoalTasksColumn: taskGoal,
      },
      where: '$emailColumn = ?',
      whereArgs: [user.email],
    );

    if (updateCount != 1) throw CouldNotUpdateUser();

    user.setDailyTaskGoal(taskGoal);

    //update user's "last change date" variable for correct syncing with cloud
    await _setUserLastChangesNow(user: user);
  }

  Future<void> updateUserDailyFlashcardGoal({
    required User user,
    required int flashcardGoal,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure user exists in database and isn't hard-coded
    final dbUser = await getDbUser(email: user.email);
    if (dbUser != user) throw CouldNotFindUser();

    final updateCount = await db.update(
      userTable,
      {
        dailyGoalFlashcardsColumn: flashcardGoal,
      },
      where: '$emailColumn = ?',
      whereArgs: [user.email],
    );

    user.setDailyFlashcardsGoal(flashcardGoal);

    if (updateCount != 1) throw CouldNotUpdateUser();
    //update user's "last change date" variable for correct syncing with cloud
    await _setUserLastChangesNow(user: user);
  }

  Future<FlashcardSet> updateFcSet({
    required FlashcardSet fcSet,
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

    final user = await getDbUser(email: fcSet.userEmail);
    //update user's "last change date" variable for correct syncing with cloud
    await _setUserLastChangesNow(user: user);

    return fcSet;
  }

  Future<Flashcard> updateFlashcard({
    required Flashcard flashcard,
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

    //update user's "last change date" variable for correct syncing with cloud
    final user = await getDbUser(email: flashcard.userEmail);
    await _setUserLastChangesNow(user: user);

    return flashcard;
  }

  Future<void> updateUserFcRushHighscore({
    required User user,
    required int value,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure user exists in database and isn't hard-coded
    final dbUser = await getDbUser(email: user.email);
    if (dbUser != user) throw CouldNotFindTask();

    final updateCount = await db.update(
      userTable,
      {
        flashcardRushHighscoreColumn: value,
      },
      where: '$emailColumn = ?',
      whereArgs: [user.email],
    );

    if (updateCount != 1) throw CouldNotUpdateTask();

    //update user's "last change date" variable for correct syncing with cloud
    user.setFlashcardRushHighscore(value);
    await _setUserLastChangesNow(user: user);
  }

  Future<void> incrUserFcsCompleted({required User user}) async {
    final db = _getDatabaseOrThrow();

    //make sure owner exists in database and isn't hard-coded
    final dbUser = await getDbUser(email: user.email);
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
      where: '$emailColumn = ?',
      whereArgs: [user.email],
    );

    if (updatesCount != 1) throw CouldnotUpdateDailyGoal();

    user.setTotalFcsCompleted(newTotalCompletedCount);
    user.setFcCompletedToday(newFlashcardsCompletedToday);

    await _updateUserStreakAfterChange(user: user);

    //update user's "last change date" variable for correct syncing with cloud
    await _setUserLastChangesNow(user: user);
  }

  Future<void> incrUserTasksCompleted({required User user}) async {
    final db = _getDatabaseOrThrow();

    //make sure owner exists in database and isn't hard-coded
    final dbUser = await getDbUser(email: user.email);
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
      where: '$emailColumn = ?',
      whereArgs: [user.email],
    );

    if (updatesCount != 1) throw CouldnotUpdateDailyGoal();

    user.setTotalTasksCompleted(newTotalCompletedCount);
    user.setTasksCompletedToday(newTasksCompletedToday);
    user.setLastStudied(DateTime.now());

    await _updateUserStreakAfterChange(user: user);

    //update user's "last change date" variable for correct syncing with cloud
    await _setUserLastChangesNow(user: user);
  }

  Future<void> incrUserIncompleteTasks({required User user}) async {
    final db = _getDatabaseOrThrow();

    //make sure owner exists in database and isn't hard-coded
    final dbUser = await getDbUser(email: user.email);
    if (dbUser != user) throw CouldNotFindUser();

    final newIncompleteTasksCount = user.totalIncompleteTasks + 1;

    final updatesCount = await db.update(
      userTable,
      {
        totalIncompleteTasksColumn: newIncompleteTasksCount,
        lastStudiedColumn: getCurrentDateAsFormattedString(),
      },
      where: '$emailColumn = ?',
      whereArgs: [user.email],
    );

    if (updatesCount != 1) throw CouldnotUpdateDailyGoal();

    user.setTotalIncompleteTasks(newIncompleteTasksCount);
    user.setLastStudied(DateTime.now());

    //update user's "last change date" variable for correct syncing with cloud
    await _setUserLastChangesNow(user: user);
  }
  // << Methods for updating user database variables <<

  Future<void> deleteUser({required User user}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: '$emailColumn = ?',
      whereArgs: [user.email.toLowerCase()],
    );

    if (deletedCount != 1) throw CouldNotDeleteUser();
  }

  Future<void> deleteTask({required Task task}) async {
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

    //update user's "last change date" variable for correct syncing with cloud
    final owner = await getDbUser(email: task.userEmail);
    await _setUserLastChangesNow(user: owner);
  }

  Future<void> deleteFcSet({required FlashcardSet fcSet}) async {
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

    //update user's "last change date" variable for correct syncing with cloud
    final owner = await getDbUser(email: fcSet.userEmail);
    await _setUserLastChangesNow(user: owner);
  }

  Future<FlashcardSet> getFcSet({required int id}) async {
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      flashcardSetTable,
      limit: 1,
      where: '$localIdColumn = ?',
      whereArgs: [id],
    );

    if (results.isEmpty) throw CouldNotFindFcSet();

    return FlashcardSet.fromRow(results.first);
  }

  Future<void> deleteFlashcard({required Flashcard flashcard}) async {
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

    //update user's "last change date" variable for correct syncing with cloud
    final user = await getDbUser(email: flashcard.userEmail);
    await _setUserLastChangesNow(user: user);
  }

  Future<Flashcard> getFlashcard({required int id}) async {
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      flashcardTable,
      limit: 1,
      where: '$localIdColumn = ?',
      whereArgs: [id],
    );

    if (results.isEmpty) throw CouldNotFindFcSet();

    return Flashcard.fromRow(results.first);
  }

  Future<FlashcardSet> getFlashcardSet({required int id}) async {
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      flashcardSetTable,
      limit: 1,
      where: '$localIdColumn = ?',
      whereArgs: [id],
    );

    if (results.isEmpty) throw CouldNotFindFcSet();

    return FlashcardSet.fromRow(results.first);
  }

  Future<User> getDbUser({required String email}) async {
    final User? user = await getUserOrNull(email: email);

    if (user == null) throw CouldNotFindUser();

    return user;
  }

  Future<User?> getUserOrNull({required String email}) async {
    final db = _getDatabaseOrThrow();

    final result = await db.query(
      userTable,
      limit: 1,
      where: '$emailColumn = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (result.isEmpty) return null;

    return User.fromRow(result.first);
  }

  Future<List<Task>> getUserTasks({required User user}) async {
    List<Task> allTasks = await _getAllDbTasks();
    return allTasks.where((task) => task.userEmail == user.email).toList();
  }

  Future<User> getNullUser() async {
    return await getDbUser(email: defaultNullUserEmail);
  }

  Future<List<FlashcardSet>> getUserFlashcardSets({required User user}) async {
    List<FlashcardSet> allFcSets = await _getAllDbFlashCardSets();
    return allFcSets.where((fcSet) => fcSet.userEmail == user.email).toList();
  }

  Future<List<Flashcard>> getUserFlashcards({required User user}) async {
    List<Flashcard> flashcards = await _getAllDbFlashcards();

    return flashcards
        .where((flashcard) => flashcard.userEmail == user.email)
        .toList();
  }

  Future<List<Flashcard>> getFlashcardsFromSet(
      {required FlashcardSet fcSet}) async {
    List<Flashcard> allFlashcards = await _getAllDbFlashcards();

    return allFlashcards
        .where((flashcard) => flashcard.flashcardSetId == fcSet.id)
        .toList();
  }

  Future<Task> getTask({required int id}) async {
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      taskTable,
      limit: 1,
      where: '$localIdColumn = ?',
      whereArgs: [id],
    );

    if (results.isEmpty) throw CouldNotFindFcSet();

    return Task.fromRow(results.first);
  }

  Future<void> setLastSynced({
    required User user,
    required DateTime date,
  }) async {
    final db = _getDatabaseOrThrow();

    //make sure user exists in database and isn't hard-coded
    final dbUser = await getDbUser(email: user.email);
    if (dbUser != user) throw CouldNotFindUser();

    final updateCount = await db.update(
      userTable,
      {
        lastSyncedColumn: getDateAsFormattedString(date),
      },
      where: '$emailColumn = ?',
      whereArgs: [user.email],
    );

    user.setLastSynced(date);

    if (updateCount != 1) throw CouldNotUpdateUser();
  }

  //Synchronizes current user with cloud. Depending on "last changes" variable, this class pushes data or pulls data from the cloud. Can be invoked only once per 15 minutes.
  Future<void> syncWithCloud() async {
    log('Syncing with cloud\n');

    var user = currentUser;

    if (user == await LocalDbController().getNullUser()) {
      throw CannotSyncNullUser();
    }
    final hasInternet = await hasInternetConectivity();
    if (!hasInternet) {
      throw NoInternetConnectionException();
    }
    //throw if user syncs too frequently
    if (DateTime.now().difference(user.lastSynced).inMinutes < 15) {
      throw CannotSyncSoFrequently();
    }

    //If userCloudId is null locally but exists in cloud:
    if (user.cloudId == null) {
      //Check if user exists in cloud db. If so, assign an id to them
      final cloudId = await CloudDbController().getUserCloudIdByEmail(
        email: user.email,
      );
      if (cloudId != null) {
        //set id and reload user
        await updateUserCloudId(user: user, cloudId: cloudId);
        user = await getDbUser(email: user.email);
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
    await setLastSynced(user: user, date: DateTime.now());
  }

  // >> PRIVATE METHODS >>
  Future<void> _deleteFlashcardsBySetId({required int fcSetId}) async {
    final db = _getDatabaseOrThrow();

    await db.delete(
      flashcardTable,
      where: '$flashcardSetIdColumn = ?',
      whereArgs: [fcSetId],
    );

    // if (deletedCount == 0) throw CouldNotDeleteFlashcard();
  }

  Future<List<Task>> _getAllDbTasks() async {
    final db = _getDatabaseOrThrow();
    final tasks = await db.query(taskTable);

    return tasks.map((taskRow) => Task.fromRow(taskRow)).toList();
  }

  //Pushes user data into cloud storage.
  Future<void> _saveAllToCloud(User user) async {
    if (isNullUser(user)) throw CannotSyncNullUser();

    await CloudDbController().saveAllToCloud(user: user);
  }

  Future<void> _updateDbUser({required User user}) async {
    final db = _getDatabaseOrThrow();

    // Convert user to JSON and remove unique fields
    final userMap = user.toJson();
    userMap.remove(cloudIdColumn);
    userMap.remove(emailColumn);

    await db.update(
      userTable,
      userMap,
      where: '$emailColumn = ?',
      whereArgs: [user.email],
    );
  }

  Future<void> _updateOrCreateFcSet({required FlashcardSet fcSet}) async {
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

  Future<void> _updateOrCreateFlashcard({required Flashcard flashcard}) async {
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

  Future<void> _updateOrCreateTask({required Task task}) async {
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

  //Loads the user data from cloud as a Data pack class and assigns the values to user passed as an argument. Should be used only via syncWithCLoud() method
  Future<void> _loadAllFromCloud(User user) async {
    final cloudUserData = await CloudDbController().loadAllFromCloud(
      user: user,
    );

    await _updateDbUser(user: cloudUserData.user);
    await setCurrentUser(user: cloudUserData.user);

    for (final task in cloudUserData.tasks) {
      log('1');
      await _updateOrCreateTask(task: task);
    }

    for (final fcSet in cloudUserData.flashcardSets) {
      log('2');
      await _updateOrCreateFcSet(fcSet: fcSet);
    }

    for (final flashcard in cloudUserData.flashcards) {
      log('3');

      await _updateOrCreateFlashcard(flashcard: flashcard);
    }

    await _reloadCurrentUser();

    await TodoService().reloadTasks();

    await FlashcardsService().reloadFlashcardSets();
  }

  Future<List<FlashcardSet>> _getAllDbFlashCardSets() async {
    final db = _getDatabaseOrThrow();

    final flashcardSets = await db.query(flashcardSetTable);

    return flashcardSets
        .map((flashcardSetRow) => FlashcardSet.fromRow(flashcardSetRow))
        .toList();
  }

  Future<List<Flashcard>> _getAllDbFlashcards() async {
    final db = _getDatabaseOrThrow();

    final flashcards = await db.query(flashcardTable);

    return flashcards
        .map((flashcardRow) => Flashcard.fromRow(flashcardRow))
        .toList();
  }

  //Resets user's tasks and flashcards finished today count. Returns updatecount as an integer
  Future<int> _resetTodaysProgress({required User user}) async {
    final db = _getDatabaseOrThrow();

    final updateCount = await db.update(
      userTable,
      {
        tasksCompletedTodayColumn: 0,
        flashcardsCompletedTodayColumn: 0,
      },
      where: '$emailColumn = ?',
      whereArgs: [user.email],
    );

    if (updateCount != 1) throw CouldNotUpdateUser();

    return updateCount;
  }

  //Resets user's days streak. Returns updatecount as an integer
  Future<int> _resetUserStreak({required User user}) async {
    final db = _getDatabaseOrThrow();

    final updateCount = await db.update(
      userTable,
      {currentDayStreakColumn: 0},
      where: '$emailColumn = ?',
      whereArgs: [user.email],
    );

    if (updateCount != 1) throw CouldNotUpdateTask();

    return updateCount;
  }

  Future<void> _initAndSetUserStreak({required User user}) async {
    int totalUpdatesCount = 0;

    //Resets user's Fcs and tasks completed today to 0 if user hadn't studied today.
    if (daysDifferenceFromNow(user.lastStudied) <= -1) {
      int updateCount = await _resetTodaysProgress(user: user);
      totalUpdatesCount += updateCount;
    }

    //Resets user's streak if user hadn't finished a daily goal for more than 1 day
    if (daysDifferenceFromNow(user.lastStreakBroken) <= -2) {
      int updateCount = await _resetUserStreak(user: user);
      totalUpdatesCount += updateCount;
    }

    if (totalUpdatesCount > 0) await _reloadCurrentUser();
  }

  //Current user is set to nullUser before logging in.
  Future<void> _initNullUser() async {
    User? nullUser = await getUserOrNull(email: defaultNullUserEmail);

    if (nullUser == null) {
      nullUser = await createUser(email: defaultNullUserEmail);
      await updateUserName(
        user: nullUser,
        name: "Not Logged In!",
      );
    }
  }

  Future<void> _reloadCurrentUser() async {
    if (_currentUser == null) throw UserNotFound();

    _currentUser = await getDbUser(email: _currentUser!.email);
  }

  //Should be invoked on every task/flashcard completed. Increases user's daily streak if daily goal has been achieved
  Future<void> _updateUserStreakAfterChange({required User user}) async {
    final db = _getDatabaseOrThrow();

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
        where: 'email = ?',
        whereArgs: [user.email],
      );

      if (updateCount != 1) throw CouldNotUpdateUser();

      user.setCurrentDayStreak(user.currentDayStreak + 1);
      if (userStreakHighscore == newDayStreak) {
        user.setStreakHighscore(userStreakHighscore);
      }
      user.setLastStreakBroken(DateTime.now());
    }
  }

  //opens database and creates tables if they do not exist yet.
  Future<void> _openDb() async {
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

  // ignore: unused_element
  Future<void> _closeDb() async {
    if (_db == null) throw DatabaseIsNotOpened();

    await _db!.close();
    _db = null;
    _currentUser = null;
  }

  //throws an exception if db is not opened.
  Database _getDatabaseOrThrow() {
    if (_db == null) throw DatabaseIsNotOpened();
    return _db!;
  }

  //Should be invoked on every user's variable change in db.
  Future<User> _setUserLastChangesNow({required User user}) async {
    final db = _getDatabaseOrThrow();

    //make sure task exists in database and isn't hard-coded
    final dbUser = await getDbUser(email: user.email);
    if (dbUser != user) throw CouldNotFindUser();

    final now = DateTime.now();

    final updateCount = await db.update(
      userTable,
      {
        lastChangesColumn: getDateAsFormattedString(now),
      },
      where: '$emailColumn = ?',
      whereArgs: [user.email],
    );

    if (updateCount != 1) throw CouldNotUpdateTask();

    user.setLastChanges(now);

    return user;
  }

  bool isNullUser(User user) => user.email == defaultNullUserEmail;

  User get currentUser =>
      initialized ? _currentUser! : throw DatabaseIsNotOpened();

  bool get initialized => _db != null && _currentUser != null;
}

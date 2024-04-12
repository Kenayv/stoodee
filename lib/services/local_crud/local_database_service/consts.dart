import 'dart:developer';

import 'package:stoodee/services/auth/auth_service.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/services/shared_prefs/shared_prefs.dart';

//FIXME: remove debug prefix
const dbName = 'debug16_tasks.db';

const userTable = 'user';
const taskTable = 'task';
const flashcardSetTable = 'flashcard_set';
const flashcardTable = 'flashcard';

const localIdColumn = 'ID';
const cloudIdColumn = 'cloud-db-id';

const emailColumn = 'email';
const lastSyncedColumn = 'last_synced_column';
const lastStreakBrokenColumn = 'last_streak_broken';
const lastStudiedColumn = 'last_studied';

const nameColumn = 'name';
const dailyGoalFlashcardsColumn = 'daily_goal_flashcards';
const dailyGoalTasksColumn = 'daily_goal_tasks';

const tasksCompletedTodayColumn = 'tasks_completed_today';
const flashcardsCompletedTodayColumn = 'flashcards_completed_today';
const dayStreakColumn = 'day_streak';

const textColumn = 'text';
const userIdColumn = 'user_id';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';

const flashcardSetIdColumn = 'flashcard_set_id';
const frontTextColumn = 'front_text';
const backTextColumn = 'back_text';

const displayAfterDateColumn = 'display_after_date';
const cardDifficultyColumn = 'card_difficulty';
const pairCountColumn = 'pair_count';

const minFlashCardDifficulty = 0;
const defaultFlashcardDifficulty = 5;
const maxFlashCardDifficulty = 10;

const defaultDailyTaskGoal = 5;
const defaultDailyFlashcardsGoal = 15;

const defaultDateStr = '1990-01-01 00:00:00';
const defaultUserName = 'Hello Dolly!';
const defaultNullUserEmail = 'null.user@stoodee.fakemail';

const createUserTable = ''' 
  CREATE TABLE IF NOT EXISTS "$userTable" (
    "$localIdColumn"	INTEGER NOT NULL UNIQUE,
    "$cloudIdColumn" TEXT UNIQUE NULL,
    "$emailColumn"	TEXT NOT NULL UNIQUE,
    "$nameColumn" TEXT NOT NULL DEFAULT "$defaultUserName",
    "$lastSyncedColumn" TEXT NOT NULL DEFAULT "$defaultDateStr",
    "$lastStreakBrokenColumn" TEXT NOT NULL DEFAULT "$defaultDateStr",
    "$lastStudiedColumn" TEXT NOT NULL DEFAULT "$defaultDateStr",
    "$dailyGoalFlashcardsColumn" INTEGER NOT NULL DEFAULT "$defaultDailyFlashcardsGoal",
    "$dailyGoalTasksColumn" INTEGER NOT NULL DEFAULT "$defaultDailyTaskGoal",
    "$flashcardsCompletedTodayColumn" INTEGER NOT NULL DEFAULT 0,
    "$tasksCompletedTodayColumn" INTEGER NOT NULL DEFAULT 0,
    "$dayStreakColumn" INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY("$localIdColumn" AUTOINCREMENT)
  );
''';

const createTaskTable = '''
  CREATE TABLE IF NOT EXISTS "$taskTable" (
    "$localIdColumn"	INTEGER NOT NULL UNIQUE,
    "$userIdColumn"	INTEGER NOT NULL,
    "$textColumn"	TEXT NOT NULL,
    PRIMARY KEY("$localIdColumn" AUTOINCREMENT),
    FOREIGN KEY("$userIdColumn") REFERENCES "$userTable"("$localIdColumn")
  );
''';

const createFlashcardSetTable = '''
  CREATE TABLE IF NOT EXISTS "$flashcardSetTable" (
    "$localIdColumn"	INTEGER NOT NULL UNIQUE,
    "$userIdColumn"	INTEGER NOT NULL,
    "$nameColumn"	TEXT NOT NULL,
    "$pairCountColumn" INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY("$localIdColumn" AUTOINCREMENT),
    FOREIGN KEY("$userIdColumn") REFERENCES "$userTable"("$localIdColumn")
  );
''';

const createFlashcardTable = '''
  CREATE TABLE  IF NOT EXISTS"$flashcardTable" (
    "$localIdColumn"	INTEGER NOT NULL UNIQUE,
    "$flashcardSetIdColumn"	INTEGER NOT NULL,
    "$frontTextColumn"	TEXT NOT NULL,
    "$backTextColumn"	TEXT NOT NULL,
    "$cardDifficultyColumn"	INTEGER NOT NULL DEFAULT "$defaultFlashcardDifficulty",
    "$displayAfterDateColumn"	TEXT NOT NULL DEFAULT "$defaultDateStr",
    PRIMARY KEY("$localIdColumn" AUTOINCREMENT),
    FOREIGN KEY("$flashcardSetIdColumn") REFERENCES "$flashcardSetTable"("$localIdColumn")
  );
''';

DateTime parseStringToDateTime(String date) {
  // Regular expression for "1990-01-01 00:00:00"-like format
  final RegExp dateRegex = RegExp(
      r'^([0-9]{4})-([0-9]{2})-([0-9]{2}) ([0-9]{2}):([0-9]{2}):([0-9]{2})$');

  if (!dateRegex.hasMatch(date)) throw Exception("Wrong date input");

  final match = dateRegex.firstMatch(date);
  if (match == null) throw Exception("Invalid date format");

  final year = int.parse(match.group(1)!);
  final month = int.parse(match.group(2)!);
  final day = int.parse(match.group(3)!);
  final hour = int.parse(match.group(4)!);
  final minute = int.parse(match.group(5)!);
  final second = int.parse(match.group(6)!);

  return DateTime(year, month, day, hour, minute, second);
}

String getDateAsFormattedString(DateTime date) {
  return date.toString().substring(0, 19);
}

String getCurrentDateAsFormattedString() {
  return getDateAsFormattedString(DateTime.now());
}

void debug___Print___info({
  required bool sharedprefs,
  required bool authService,
  required bool localDbUser,
}) {
  String allDebugStrings;
  allDebugStrings = '[START] ALL INFO PRINT [START]\n\n';

  if (sharedprefs) {
    allDebugStrings +=
        'Initialized [sharedPrefs] with values:\n   remember has seen intro = [${SharedPrefs().rememberHasSeenIntro}]\n   remember Login Data = [${SharedPrefs().rememberLoginData}]\n\n\n';
  }
  if (authService) {
    allDebugStrings +=
        'Initialized AuthService with values:\n   Current user = [${AuthService.firebase().currentUser ?? 'null'}]\n\n\n';
  }
  if (localDbUser) {
    allDebugStrings +=
        'Initialized localdb with values:\n   Current user = [${LocalDbController().currentUser.toString()}]\n\n';
  }

  allDebugStrings += '[END] Debug log After Init [END]\n.';

  log(allDebugStrings);
}

/// Returns the difference (in full days) between the provided date and today.
int daysDifferenceFromNow(DateTime dateArg) {
  final now = DateTime.now();

  // get Argument's date and Today's date without hours:minutes:seconds
  DateTime date = DateTime(dateArg.year, dateArg.month, dateArg.day);
  DateTime today = DateTime(now.year, now.month, now.day);

  //return difference in days between given date and today
  return date.difference(today).inDays;
}

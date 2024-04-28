const dbName = 'tasks.db';

const userTable = 'user';
const taskTable = 'task';
const flashcardSetTable = 'flashcard_set';
const flashcardTable = 'flashcard';

const localIdColumn = 'ID';
const cloudIdColumn = 'cloud_db_id';

const emailColumn = 'email';
const lastChangesColumn = 'last_changes';
const lastStreakBrokenColumn = 'last_streak_broken';
const lastStudiedColumn = 'last_studied';

const totalFlashcardsCompletedColumn = 'total_flashcards_completed';
const totalTasksCompletedColumn = 'total_tasks_completed';

const nameColumn = 'name';
const dailyGoalFlashcardsColumn = 'daily_goal_flashcards';
const dailyGoalTasksColumn = 'daily_goal_tasks';
const lastSyncedColumn = 'last_synced';

const tasksCompletedTodayColumn = 'tasks_completed_today';
const flashcardsCompletedTodayColumn = 'flashcards_completed_today';
const currentDayStreakColumn = 'current_day_streak';

const textColumn = 'text';
const userIdColumn = 'user_id';

const flashcardSetIdColumn = 'flashcard_set_id';
const frontTextColumn = 'front_text';
const backTextColumn = 'back_text';

const streakHighscoreColumn = 'streak_highscore';
const flashcardRushHighscoreColumn = 'flashcard_rush_highscore';
const totalIncompleteTasksColumn = 'total_incomplete_tasks';

const displayDateColumn = 'display_date';
const cardDifficultyColumn = 'card_difficulty';
const pairCountColumn = 'pair_count';

const defaultFlashcardDifficulty = 8;
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
    "$lastChangesColumn" TEXT NOT NULL DEFAULT "$defaultDateStr",
    "$lastSyncedColumn" TEXT NOT NULL DEFAULT "$defaultDateStr",
    "$lastStreakBrokenColumn" TEXT NOT NULL DEFAULT "$defaultDateStr",
    "$lastStudiedColumn" TEXT NOT NULL DEFAULT "$defaultDateStr",
    "$dailyGoalFlashcardsColumn" INTEGER NOT NULL DEFAULT "$defaultDailyFlashcardsGoal",
    "$dailyGoalTasksColumn" INTEGER NOT NULL DEFAULT "$defaultDailyTaskGoal",
    "$flashcardsCompletedTodayColumn" INTEGER NOT NULL DEFAULT 0,
    "$tasksCompletedTodayColumn" INTEGER NOT NULL DEFAULT 0,
    "$currentDayStreakColumn" INTEGER NOT NULL DEFAULT 0,
    "$streakHighscoreColumn" INTEGER NOT NULL DEFAULT 0,
    "$totalFlashcardsCompletedColumn" INTEGER NOT NULL DEFAULT 0,
    "$totalTasksCompletedColumn" INTEGER NOT NULL DEFAULT 0,
    "$totalIncompleteTasksColumn" INTEGER NOT NULL DEFAULT 0,
    "$flashcardRushHighscoreColumn" INTEGER NOT NULL DEFAULT 0,
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
    "$userIdColumn"	INTEGER NOT NULL,
    "$frontTextColumn"	TEXT NOT NULL,
    "$backTextColumn"	TEXT NOT NULL,
    "$cardDifficultyColumn"	INTEGER NOT NULL DEFAULT "$defaultFlashcardDifficulty",
    "$displayDateColumn"	TEXT NOT NULL DEFAULT "$defaultDateStr",
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

/// Returns the difference (in full days) between the provided date and today.
int daysDifferenceFromNow(DateTime dateArg) {
  final now = DateTime.now();

  // get Argument's date and Today's date without hours:minutes:seconds
  DateTime date = DateTime(dateArg.year, dateArg.month, dateArg.day);
  DateTime today = DateTime(now.year, now.month, now.day);

  //return difference in days between given date and today
  return date.difference(today).inDays;
}

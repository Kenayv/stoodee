//FIXME: remove debug prefix
const dbName = 'debug3_tasks.db';

const userTable = 'user';
const taskTable = 'task';
const flashcardSetTable = 'flashcard_set';
const flashcardTable = 'flashcard';

const idColumn = 'ID';
const emailColumn = 'email';
const lastSyncedColumn = 'lastSyncedColumn';

const textColumn = 'text';
const userIdColumn = 'user_id';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';

const flashcardSetIdColumn = 'flashcard_set_id';
const frontTextColumn = 'front_text';
const backTextColumn = 'back_text';

const displayAfterDate = 'display_after_date';
const cardDifficultyColumn = 'card_difficulty';
const nameColumn = 'name';

const defaultDateStringValue = '1990-01-01 00:00:00';
const notLoggedInUserEmail = 'null.user@stoodee.fakemail';

const createUserTable = ''' 
  CREATE TABLE IF NOT EXISTS "$userTable" (
    "$idColumn"	INTEGER NOT NULL UNIQUE,
    "$emailColumn"	TEXT NOT NULL UNIQUE,
    "$lastSyncedColumn" TEXT NOT NULL DEFAULT '$defaultDateStringValue',
    PRIMARY KEY("$idColumn" AUTOINCREMENT)
  );
''';

const createTaskTable = '''
  CREATE TABLE IF NOT EXISTS "$taskTable" (
    "$idColumn"	INTEGER NOT NULL UNIQUE,
    "$userIdColumn"	INTEGER NOT NULL,
    "$textColumn"	TEXT NOT NULL,
    PRIMARY KEY("$idColumn" AUTOINCREMENT),
    FOREIGN KEY("$userIdColumn") REFERENCES "$userTable"("$idColumn")
  );
''';

const createFlashcardSetTable = '''
  CREATE TABLE "$flashcardSetTable" (
    "$idColumn"	INTEGER NOT NULL UNIQUE,
    "$userIdColumn"	INTEGER NOT NULL,
    "$nameColumn"	TEXT NOT NULL,
    PRIMARY KEY("$idColumn" AUTOINCREMENT),
    FOREIGN KEY("$userIdColumn") REFERENCES "$userTable"("$idColumn")
  );
''';

const createFlashcardTable = '''
  CREATE TABLE "$flashcardTable" (
    "$idColumn"	INTEGER NOT NULL UNIQUE,
    "$flashcardSetIdColumn"	INTEGER NOT NULL,
    "$frontTextColumn"	TEXT NOT NULL,
    "$backTextColumn"	TEXT NOT NULL,
    "$displayAfterDate"	TEXT NOT NULL DEFAULT '$defaultDateStringValue',
    "$cardDifficultyColumn"	INTEGER NOT NULL DEFAULT 1,
    PRIMARY KEY("$idColumn" AUTOINCREMENT),
    FOREIGN KEY("$flashcardSetIdColumn") REFERENCES "$flashcardSetTable"("$idColumn")
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

String getCurrentDateAsFormattedString() {
  return DateTime.now().toString().substring(0, 19);
}
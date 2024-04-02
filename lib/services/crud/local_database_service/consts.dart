const dbName = 'tasks.db';

//FIXME: remove debug prefix
const taskTable = 'debug1_task';
const userTable = 'debug1_user';

const idColumn = 'ID';
const userIdColumn = 'user_id';
const emailColumn = 'email';
const textColumn = 'text';
const showAfterDateColumn = 'show_after_date';
const lastEditedColumn = 'last_edited';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';
const difficultyColumn = 'difficulty';

const notLoggedInUserEmail = 'null.user@stoodee.fakemail';

const createUserTable = ''' 
  CREATE TABLE IF NOT EXISTS "$userTable" (
    "$idColumn"	INTEGER NOT NULL UNIQUE,
    "$emailColumn"	TEXT NOT NULL UNIQUE,
    PRIMARY KEY("$idColumn" AUTOINCREMENT)
  );
''';

const createTaskTable = '''
  CREATE TABLE IF NOT EXISTS "$taskTable" (
    "$idColumn"	INTEGER NOT NULL UNIQUE,
    "$userIdColumn"	INTEGER NOT NULL,
    "$textColumn"	TEXT NOT NULL,
    "$lastEditedColumn" TEXT NOT NULL,
    "$isSyncedWithCloudColumn"	INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY("$idColumn" AUTOINCREMENT),
    FOREIGN KEY("$userIdColumn") REFERENCES "$userTable"("$idColumn")
  );
''';

DateTime parseStringToDateTime(String date) {
  // Regular expression for "2024-01-24 12:00:00"-like format
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

//FIXME: ugly ahh
String getCurrentDateAsFormattedString() {
  return DateTime.now().toString().substring(0, 19);
}

const dbName = 'tasks.db';

const taskTable = 'task';
const userTable = 'user';

const idColumn = 'ID';
const userIdColumn = 'user_id';
const emailColumn = 'email';
const textColumn = 'text';
const showAfterDateColumn = 'show_after_date';
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
    "$isSyncedWithCloudColumn"	INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY("$idColumn" AUTOINCREMENT),
    FOREIGN KEY("$userIdColumn") REFERENCES "$userTable"("$idColumn")
  );
''';

DateTime parseStringToDateTime(String date) {
  //Regular expression for "2024-01-01"-like format
  final RegExp dateRegex =
      RegExp(r'^([0-9][0-9][0-9][0-9])\-([0-9][0-9])\-([0-9][0-9])$');

  if (!dateRegex.hasMatch(date)) throw Exception("Wrong date input");

  final List<int> yearMonthDay = date.split('-').map(int.parse).toList();
  return DateTime(yearMonthDay[0], yearMonthDay[1], yearMonthDay[2]);
}

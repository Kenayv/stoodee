const dbName = 'tasks.db';

const taskTable = 'task';
const userTable = 'user';

const idColumn = 'ID';
const userIdColumn = 'user_id';
const emailColumn = 'email';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';

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
    "text"	TEXT NOT NULL,
    "$isSyncedWithCloudColumn"	INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY("$idColumn" AUTOINCREMENT),
    FOREIGN KEY("$userIdColumn") REFERENCES "$userTable"("$idColumn")
  );
''';

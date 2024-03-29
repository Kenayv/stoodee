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
  CREATE TABLE IF NOT EXISTS "user" (
    "ID"	INTEGER NOT NULL UNIQUE,
    "email"	TEXT NOT NULL UNIQUE,
    PRIMARY KEY("ID" AUTOINCREMENT)
  );
''';

const createTaskTable = '''
  CREATE TABLE IF NOT EXISTS "task" (
    "ID"	INTEGER NOT NULL UNIQUE,
    "user_id"	INTEGER NOT NULL,
    "text"	TEXT NOT NULL,
    "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY("ID" AUTOINCREMENT),
    FOREIGN KEY("user_id") REFERENCES "user"("ID")
  );
''';

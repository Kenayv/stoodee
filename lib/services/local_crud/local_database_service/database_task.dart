import 'package:stoodee/services/local_crud/local_database_service/consts.dart';

class DatabaseTask {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseTask({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });

  DatabaseTask.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      "\nTaskId = [$id]:\n   text = [$text],\n   userId = [$userId],\n   isSyncedWithCloud = [$isSyncedWithCloud]\n";

  @override
  bool operator ==(covariant DatabaseTask other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

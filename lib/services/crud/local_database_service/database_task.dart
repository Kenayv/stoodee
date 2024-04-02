import 'package:stoodee/services/crud/local_database_service/consts.dart';

class DatabaseTask {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;
  DateTime lastEdited;

  DatabaseTask(
      {required this.id,
      required this.userId,
      required this.text,
      required this.isSyncedWithCloud,
      required this.lastEdited});

  DatabaseTask.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        lastEdited = parseStringToDateTime(map[lastEditedColumn] as String),
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      "\nTask [$id]:\ntext = [$text],\nuserId = [$userId],\nlastEdited = [${lastEdited.toString()}]\nisSyncedWithCloud = [$isSyncedWithCloud]\n";

  @override
  bool operator ==(covariant DatabaseTask other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

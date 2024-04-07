import 'package:stoodee/services/local_crud/local_database_service/consts.dart';

//FIXME: remove synced with cloud
class DatabaseTask {
  final int id;
  final int userId;
  final String text; //FIXME: make this changable to optimize db loading.

  DatabaseTask({
    required this.id,
    required this.userId,
    required this.text,
  });

  DatabaseTask.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String;

  @override
  String toString() =>
      "\nTaskId = [$id]:\n   text = [$text],\n   userId = [$userId],\n";

  @override
  bool operator ==(covariant DatabaseTask other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

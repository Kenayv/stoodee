import 'package:stoodee/services/local_crud/local_database_service/consts.dart';

class DatabaseTask {
  final int id;
  final int userId;
  String _text; //FIXME: make this changable in localdbcontroller using setText

  DatabaseTask({
    required this.id,
    required this.userId,
    required String text,
  }) : _text = text;

  DatabaseTask.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        _text = map[textColumn] as String;

  @override
  String toString() =>
      "\nTaskId = [$id]:\n   text = [$_text],\n   userId = [$userId],\n";

  @override
  bool operator ==(covariant DatabaseTask other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

  String get text => _text;
  void setText(String text) => _text = text;
}

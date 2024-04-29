import 'package:stoodee/services/local_crud/local_database_service/consts.dart';

class Task {
  final int id;
  final int userId;
  final String _text;

  Task({
    required this.id,
    required this.userId,
    required String text,
  }) : _text = text;

  Task.fromRow(Map<String, Object?> map)
      : id = map[localIdColumn] as int,
        userId = map[userIdColumn] as int,
        _text = map[textColumn] as String;

  @override
  String toString() =>
      "\nTaskId = [$id]:\n   text = [$_text],\n   userId = [$userId],\n";

  Map<String, dynamic> toJson() => {
        localIdColumn: id,
        userIdColumn: userId,
        textColumn: _text,
      };

  @override
  bool operator ==(covariant Task other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

  String get text => _text;
}

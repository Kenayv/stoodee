import 'package:stoodee/services/local_crud/local_database_service/consts.dart';

class Task {
  final int id;
  final String userEmail;
  final String _text;

  Task({
    required this.id,
    required this.userEmail,
    required String text,
  }) : _text = text;

  Task.fromRow(Map<String, Object?> map)
      : id = map[localIdColumn] as int,
        userEmail = map[userEmailColumn] as String,
        _text = map[textColumn] as String;

  @override
  String toString() =>
      "\nTaskId = [$id]:\n   text = [$_text],\n   userEmail = [$userEmail],\n";

  Map<String, dynamic> toJson() => {
        localIdColumn: id,
        userEmailColumn: userEmail,
        textColumn: _text,
      };

  @override
  bool operator ==(covariant Task other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

  String get text => _text;
}

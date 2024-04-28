import 'package:stoodee/services/local_crud/local_database_service/consts.dart';

class DatabaseFlashcardSet {
  final int id;
  final int userId;
  String _name;
  int _pairCount;

  DatabaseFlashcardSet({
    required this.id,
    required this.userId,
    required String name,
    required int pairCount,
  })  : _pairCount = pairCount,
        _name = name;

  DatabaseFlashcardSet.fromRow(Map<String, Object?> map)
      : id = map[localIdColumn] as int,
        userId = map[userIdColumn] as int,
        _name = map[nameColumn] as String,
        _pairCount = map[pairCountColumn] as int;

  @override
  String toString() =>
      "FcSetId = [$id]:\n   name = [$_name],\n   userId = [$userId]\n   pairCount = [$_pairCount]\n"; // Access _pairCount directly

  Map<String, dynamic> toJson() => {
        localIdColumn: id,
        userIdColumn: userId,
        nameColumn: _name,
        pairCountColumn: _pairCount,
      };

  @override
  bool operator ==(covariant DatabaseFlashcardSet other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

  String get name => _name;
  int get pairCount => _pairCount;

  void setName(String name) => _name = name;
  void setPairCount(int val) => _pairCount = val;
}

import 'package:stoodee/services/local_crud/local_database_service/consts.dart';

class DatabaseFlashcardSet {
  final int id;
  final int userId;
  final String name; //FIXME: add set name function
  int _pairCount;

  DatabaseFlashcardSet({
    required this.id,
    required this.userId,
    required this.name,
    required int pairCount,
  }) : _pairCount = pairCount;

  DatabaseFlashcardSet.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        name = map[nameColumn] as String,
        _pairCount = map[pairCountColumn] as int;

  @override
  String toString() =>
      "FcSetId = [$id]:\n   name = [$name],\n   userId = [$userId]\n   pairCount = [$_pairCount]\n"; // Access _pairCount directly

  @override
  bool operator ==(covariant DatabaseFlashcardSet other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

  int get pairCount => _pairCount;

  void setPairCount(int val) {
    _pairCount = val;
  }
}

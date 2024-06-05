import 'package:stoodee/services/local_crud/local_database_service/consts.dart';

class FlashcardSet {
  final int id;
  final String userEmail;
  String _name;
  int _pairCount;

  FlashcardSet({
    required this.id,
    required this.userEmail,
    required String name,
    required int pairCount,
  })  : _pairCount = pairCount,
        _name = name;

  FlashcardSet.fromRow(Map<String, Object?> map)
      : id = map[localIdColumn] as int,
        userEmail = map[userEmailColumn] as String,
        _name = map[nameColumn] as String,
        _pairCount = map[pairCountColumn] as int;

  @override
  String toString() =>
      "FcSetId = [$id]:\n   name = [$_name],\n   userEmail = [$userEmail]\n   pairCount = [$_pairCount]\n"; // Access _pairCount directly

  Map<String, dynamic> toJson() => {
        localIdColumn: id,
        userEmailColumn: userEmail,
        nameColumn: _name,
        pairCountColumn: _pairCount,
      };

  @override
  bool operator ==(covariant FlashcardSet other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

  String get name => _name;
  int get pairCount => _pairCount;

  void setName(String name) => _name = name;
  void setPairCount(int val) => _pairCount = val;
}

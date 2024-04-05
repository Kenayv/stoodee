import 'package:stoodee/services/local_crud/local_database_service/consts.dart';

class DatabaseFlashcardSet {
  final int id;
  final int userId;
  final String name;
  final int pairCount;

  DatabaseFlashcardSet({
    required this.id,
    required this.userId,
    required this.name,
    required this.pairCount,
  });

  DatabaseFlashcardSet.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        name = map[nameColumn] as String,
        pairCount = map[pairCountColumn] as int;

  @override
  String toString() =>
      "FcSetId = [$id]:\n   name = [$name],\n   userId = [$userId]\n   pairCount = [$pairCount]\n";

  @override
  bool operator ==(covariant DatabaseFlashcardSet other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

  //FIXME: move to fcService
  // List<DatabaseFlashcard> get flashcards => _flashcards;
}

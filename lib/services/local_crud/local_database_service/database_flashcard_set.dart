import 'package:stoodee/services/local_crud/local_database_service/consts.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard.dart';

class DatabaseFlashcardSet {
  final int id;
  final int userId;
  final String name;

  late final List<DatabaseFlashcard> _flashcards;

  DatabaseFlashcardSet({
    required this.id,
    required this.userId,
    required this.name,
  });

  init() {
    _flashcards = [];
  }

  DatabaseFlashcardSet.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        name = map[nameColumn] as String;

  @override
  String toString() =>
      "\nTaskId = [$id]:\n   name = [$name],\n   userId = [$userId]";

  @override
  bool operator ==(covariant DatabaseFlashcard other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

  List<DatabaseFlashcard> get flashcards => _flashcards;
  int get pairCount => _flashcards.length;
}

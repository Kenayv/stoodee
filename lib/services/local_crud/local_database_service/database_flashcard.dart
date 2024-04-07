import 'package:stoodee/services/local_crud/local_database_service/consts.dart';

class DatabaseFlashcard {
  final int id;
  final int flashcardSetId;
  final String frontText; //FIXME: make those changable to optimize db loading.
  final String backText;
  final int cardDifficulty;
  final DateTime displayAfterDate;

  DatabaseFlashcard({
    required this.id,
    required this.flashcardSetId,
    required this.frontText,
    required this.backText,
    required this.cardDifficulty,
    required this.displayAfterDate,
  });

  DatabaseFlashcard.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        flashcardSetId = map[flashcardSetIdColumn] as int,
        frontText = map[frontTextColumn] as String,
        backText = map[backTextColumn] as String,
        cardDifficulty = map[cardDifficultyColumn] as int,
        displayAfterDate =
            parseStringToDateTime(map[displayAfterDateColumn] as String);

  @override
  String toString() =>
      "Flashcard id = [$id]\n   Set id = [$flashcardSetId]\n   text = [f: $frontText |b: $backText]\n   difficulty = [$cardDifficulty]\n   display after: $displayAfterDate";

  @override
  bool operator ==(covariant DatabaseFlashcard other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

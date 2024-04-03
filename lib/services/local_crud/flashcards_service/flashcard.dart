import 'package:stoodee/services/local_crud/local_database_service/consts.dart';

//FIXME: not finished not tested
class DatabaseFlashcard {
  final int id;
  final int flashcardSetId;
  final String frontText;
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

  //FIXME not finished
  @override
  String toString() => super.toString();

  @override
  bool operator ==(covariant DatabaseFlashcard other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

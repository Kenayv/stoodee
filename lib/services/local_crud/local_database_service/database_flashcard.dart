import 'package:stoodee/services/local_crud/local_database_service/consts.dart';

class DatabaseFlashcard {
  final int id;
  final int flashcardSetId;
  final int userId;
  late String _frontText; //FIXME: make those changable in localdbcontroller
  late String _backText;
  late int _cardDifficulty;
  late DateTime _displayAfterDate;

  DatabaseFlashcard({
    required this.id,
    required this.flashcardSetId,
    required this.userId,
    required String frontText,
    required String backText,
    required int cardDifficulty,
    required DateTime displayAfterDate,
  })  : _frontText = frontText,
        _backText = backText,
        _cardDifficulty = cardDifficulty,
        _displayAfterDate = displayAfterDate;

  DatabaseFlashcard.fromRow(Map<String, Object?> map)
      : id = map[localIdColumn] as int,
        flashcardSetId = map[flashcardSetIdColumn] as int,
        userId = map[userIdColumn] as int,
        _frontText = map[frontTextColumn] as String,
        _backText = map[backTextColumn] as String,
        _cardDifficulty = map[cardDifficultyColumn] as int,
        _displayAfterDate =
            parseStringToDateTime(map[displayAfterDateColumn] as String);

  @override
  String toString() =>
      "Flashcard id = [$id]\n   Set id = [$flashcardSetId]\n   text = [f: $frontText |b: $backText]\n   difficulty = [$cardDifficulty]\n   display after: $displayAfterDate\n";

  @override
  bool operator ==(covariant DatabaseFlashcard other) => id == other.id;

  Map<String, dynamic> toJson() => {
        localIdColumn: id,
        flashcardSetIdColumn: flashcardSetId,
        userIdColumn: userId,
        frontTextColumn: _frontText,
        backTextColumn: _backText,
        cardDifficultyColumn: _cardDifficulty,
        displayAfterDateColumn: getDateAsFormattedString(_displayAfterDate),
      };

  @override
  int get hashCode => id.hashCode;

  int get cardDifficulty => _cardDifficulty;
  String get frontText => _frontText;
  String get backText => _backText;
  DateTime get displayAfterDate => _displayAfterDate;

  void setCardDifficulty(int cardDifficulty) =>
      _cardDifficulty = cardDifficulty;
  void setFrontText(String frontText) => _frontText = frontText;
  void setBackText(String backText) => _backText = backText;
  void setDisplayAfter(DateTime displayAfterDate) =>
      _displayAfterDate = displayAfterDate;
}

import 'package:stoodee/services/flashcards_service/flashcard.dart';

class FlashCardSet {
  String name;
  late final List<Flashcard> _flashcards;

  FlashCardSet({required this.name});

  init() {} //FIXME:

  //FIXME: I don't know how it will be saved yet.
  Future<void> _loadFlashcards() async {} //FIXME:
  Future<void> _saveFlashcards() async {} //FIXME:
  Future<void> load() async {} //FIXME:
  Future<void> save() async {} //FIXME:

  Future<void> addFlashcard({
    required String frontText,
    required String backText,
  }) async {} //FIXME:

  Future<void> editFlashcard({
    required Flashcard flashcard,
    required String frontText,
    required String backText,
  }) async {} //FIXME:

  Future<void> removeFlashcard({
    required Flashcard flashcard,
  }) async {} //FIXME:

  Future<void> editName({required String name}) async {} //FIXME:

  List<Flashcard> get flashcards => _flashcards;
  int get pairCount => _flashcards.length;
}

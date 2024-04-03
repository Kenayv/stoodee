import 'package:stoodee/services/local_crud/flashcards_service/flashcard.dart';
import 'package:stoodee/services/local_crud/flashcards_service/flashcards_exceptions.dart';

class DatabaseFlashcardSet {
  String name;
  late final List<DatabaseFlashcard> _flashcards;
  bool _initialized = false;

  DatabaseFlashcardSet({required this.name});

  init() {
    if (_initialized) throw FcSetAlreadyInitialized();

    _flashcards = [];
    _loadFlashcards();
    _initialized = true;
  }

  Future<void> _loadFlashcards() async {} //FIXME:
  Future<void> _saveFlashcards() async {} //FIXME:

  Future<void> addFlashcard({
    required String frontText,
    required String backText,
  }) async {
    if (!_initialized) throw FcSetNotInitialized();

    //FIXME:
  }

  Future<void> editFlashcard({
    required DatabaseFlashcard flashcard,
    required String frontText,
    required String backText,
  }) async {
    if (!_initialized) throw FcSetNotInitialized();

    //FIXME:
  }

  Future<void> removeFlashcard({
    required DatabaseFlashcard flashcard,
  }) async {
    if (!_initialized) throw FcSetNotInitialized();

    //FIXME:
  }

  Future<void> editName({required String name}) async {
    if (!_initialized) throw FcSetNotInitialized();

    //FIXME:
  }

  List<DatabaseFlashcard> get flashcards =>
      _initialized ? _flashcards : throw FcSetNotInitialized();

  int get pairCount =>
      _initialized ? _flashcards.length : throw FcSetNotInitialized();
}

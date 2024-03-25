import 'package:stoodee/services/flashcards_service/flashcard.dart';
import 'package:stoodee/services/flashcards_service/flashcard_set.dart';

class FlashcardService {
  late final List<FlashcardSet> _flashcardSets;

  //ToDoService should be only used via singleton //
  static final FlashcardService _shared = FlashcardService._sharedInstance();
  factory FlashcardService() => _shared;
  FlashcardService._sharedInstance();
  //ToDoService should be only used via singleton //

  init() {}

  Future<void> _loadFcSets() async {} //FIXME:
  Future<void> _saveFcSets() async {} //FIXME:

  Future<void> addSet({
    required String name,
  }) async {} //FIXME:

  Future<void> removeSet({
    required FlashcardSet fcSet,
  }) async {} //FIXME:

  Future<void> renameSet({
    required FlashcardSet fcSet,
    required String newName,
  }) async {} //FIXME:

  Future<void> removeCard({
    required Flashcard flashcard,
  }) async {} //FIXME:

  Future<void> addCardToset({
    required FlashcardSet fcSet,
    required String frontText,
    required String backText,
  }) async {} //FIXME:

  Future<void> editCard({
    required Flashcard flashcard,
    required String frontText,
    required String backText,
  }) async {} //FIXME:

  List<FlashcardSet> get fcSets => _flashcardSets;
}

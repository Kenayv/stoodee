import 'package:stoodee/services/flashcards_service/flashcard.dart';
import 'package:stoodee/services/flashcards_service/flashcard_set.dart';

class FlashCardService {
  late final List<FlashCardSet> _flashcardSets;

  //ToDoService should be only used via singleton //
  static final FlashCardService _shared = FlashCardService._sharedInstance();
  factory FlashCardService() => _shared;
  FlashCardService._sharedInstance();
  //ToDoService should be only used via singleton //

  init() {}

  Future<void> _loadFcSets() async {}
  Future<void> _saveFcSets() async {}

  Future<void> addSet({
    required String name,
  }) async {}

  Future<void> removeSet({
    required FlashCardSet fcSet,
  }) async {}

  Future<void> renameSet({
    required FlashCardSet fcSet,
    required String newName,
  }) async {}

  Future<void> removeCard({
    required Flashcard flashcard,
  }) async {}

  Future<void> addCardToset({
    required FlashCardSet fcSet,
    required String frontText,
    required String backText,
  }) async {}

  Future<void> editCard({
    required Flashcard flashcard,
    required String frontText,
    required String backText,
  }) async {}

  List<FlashCardSet> get fcSets => _flashcardSets;
}

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

  Future<void> _loadFcSets() async {} //FIXME:
  Future<void> _saveFcSets() async {} //FIXME:

  Future<void> addSet({
    required String name,
  }) async {} //FIXME:

  Future<void> removeSet({
    required FlashCardSet fcSet,
  }) async {} //FIXME:

  Future<void> renameSet({
    required FlashCardSet fcSet,
    required String newName,
  }) async {} //FIXME:

  Future<void> removeCard({
    required Flashcard flashcard,
  }) async {} //FIXME:

  Future<void> addCardToset({
    required FlashCardSet fcSet,
    required String frontText,
    required String backText,
  }) async {} //FIXME:

  Future<void> editCard({
    required Flashcard flashcard,
    required String frontText,
    required String backText,
  }) async {} //FIXME:

  List<FlashCardSet> get fcSets => _flashcardSets;
}

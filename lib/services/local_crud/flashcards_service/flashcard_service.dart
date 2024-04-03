import 'package:stoodee/services/local_crud/flashcards_service/flashcard.dart';
import 'package:stoodee/services/local_crud/flashcards_service/flashcard_set.dart';
import 'package:stoodee/services/local_crud/flashcards_service/flashcards_exceptions.dart';

class FlashcardService {
  late final List<FlashcardSet> _flashcardSets;
  bool _initialized = false;

  //ToDoService should be only used via singleton //
  static final FlashcardService _shared = FlashcardService._sharedInstance();
  factory FlashcardService() => _shared;
  FlashcardService._sharedInstance();
  //ToDoService should be only used via singleton //

  init() {
    if (_initialized) throw FcServiceAlreadyInitialized();

    _loadFcSets();

    _initialized = true;
  }

  Future<void> _loadFcSets() async {
    _flashcardSets = [];
    //FIXME:
  }

  Future<void> _saveFcSets() async {
    if (!_initialized) throw FcServiceNotInitialized();

    //FIXME:
  }

  Future<void> addSet({
    required String name,
  }) async {
    if (!_initialized) throw FcServiceNotInitialized();

    if (_flashcardSets.where((o) => o.name == name).firstOrNull != null) {
      throw FcSetAlreadyExists;
    }

    FlashcardSet fcSet = FlashcardSet(name: name);
    await fcSet.init();
    _flashcardSets.add(fcSet);

    await _saveFcSets();
  }

  Future<void> removeSet({
    required FlashcardSet fcSet,
  }) async {
    if (!_initialized) throw FcServiceNotInitialized();

    FlashcardSet? fcSetToRemove =
        _flashcardSets.where((o) => o.name == fcSet.name).firstOrNull;

    if (fcSetToRemove == null) {
      throw FcSetDoesNotExist;
    }

    _flashcardSets.remove(fcSetToRemove);

    await _saveFcSets();
  }

  Future<void> renameSet({
    required FlashcardSet fcSet,
    required String newName,
  }) async {
    if (!_initialized) throw FcServiceNotInitialized();

    FlashcardSet? fcSetToRename =
        _flashcardSets.where((o) => o.name == fcSet.name).firstOrNull;

    if (fcSetToRename == null) {
      throw FcSetDoesNotExist;
    }

    fcSetToRename.name = newName;

    await _saveFcSets();
  }

  Future<void> removeCardFromFcSet({
    required Flashcard flashcard,
    required FlashcardSet fcSet,
  }) async {
    if (!_initialized) throw FcServiceNotInitialized();

    //FIXME:
  }

  Future<void> addCardToset({
    required FlashcardSet fcSet,
    required String frontText,
    required String backText,
  }) async {
    if (!_initialized) throw FcServiceNotInitialized();

    //FIXME:
  }

  Future<void> editCard({
    required Flashcard flashcard,
    required String frontText,
    required String backText,
  }) async {
    if (!_initialized) throw FcServiceNotInitialized();

    flashcard.editCard(frontText: frontText, backText: backText);

    await _saveFcSets();
  }

  List<FlashcardSet> get fcSets => _flashcardSets;
}

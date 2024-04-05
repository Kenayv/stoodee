import 'dart:developer';

import 'package:stoodee/services/local_crud/local_database_service/database_flashcard.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';

import 'crud_exceptions.dart';

class FlashcardService {
  late final List<DatabaseFlashcardSet>? _flashcardSets;
  bool _initialized = false;
  //ToDoService should be only used via singleton //
  static final FlashcardService _shared = FlashcardService._sharedInstance();
  factory FlashcardService() => _shared;
  FlashcardService._sharedInstance();
  //ToDoService should be only used via singleton //

  Future<List<DatabaseFlashcardSet>> getFlashcardSets() async {
    await _loadFcSets();

    return _flashcardSets!;
  }

  Future<List<DatabaseFlashcardSet>> _loadFcSets() async {
    if (!_initialized) {
      _flashcardSets = await LocalDbController().getUserFlashcardSets(
        user: LocalDbController().currentUser,
      );
      _initialized = true;
    }

    //FIXME: debug log
    String debugLogStart = "[START] loading FlashcardSets [START]\n\n";
    String debugLogFlashcardSets = "$_flashcardSets\n\n";
    String debugLogEnd = "[END] loading FlashcardSets [END]\n.";

    log(debugLogStart + debugLogFlashcardSets + debugLogEnd);

    return _flashcardSets!;
  }

  Future<List<DatabaseFlashcard>> loadFlashcardsFromSet(
      {required DatabaseFlashcardSet fcSet}) async {
    final flashcards = await LocalDbController().getFlashcardsFromSet(
      fcSet: fcSet,
    );

    //FIXME: debug log
    String debugLogStart = "[START] loading Flashcards [START]\n\n";
    String debugLogFlashcards = "$flashcards\n\n";
    String debugLogEnd = "[END] loading Flashcards [END]\n.";

    log(debugLogStart + debugLogFlashcards + debugLogEnd);

    return flashcards.where((card) => card.flashcardSetId == fcSet.id).toList();
  }

  Future<DatabaseFlashcardSet> createFcSet({required String name}) async {
    if (!_initialized) throw FcServiceNotInitialized();

    final fcSet = await LocalDbController().createFcSet(
      owner: LocalDbController().currentUser,
      name: name,
    );

    _flashcardSets!.add(fcSet);
    return fcSet;
  }

  Future<void> removeFcSet(DatabaseFlashcardSet fcSet) async {
    if (!_initialized) throw FcServiceNotInitialized();

    await LocalDbController().deleteFcSet(fcSet: fcSet);
    _flashcardSets!.removeWhere((fcSetToRemove) => fcSetToRemove == fcSet);
  }

  Future<void> renameFcSet({
    required DatabaseFlashcardSet fcSet,
    required String name,
  }) async {
    if (!_initialized) throw FcServiceNotInitialized();

    await LocalDbController().updateFcSet(
      fcSet: fcSet,
      name: name,
    );
  }

  Future<void> removeFlashcard({
    required DatabaseFlashcard flashcard,
  }) async {
    if (!_initialized) throw FcServiceNotInitialized();

    await LocalDbController().deleteFlashcard(flashcard: flashcard);
  }

  Future<DatabaseFlashcard> createFlashcard({
    required DatabaseFlashcardSet fcSet,
    required String frontText,
    required String backText,
  }) async {
    if (!_initialized) throw FcServiceNotInitialized();

    return await LocalDbController().createFlashcard(
      fcSet: fcSet,
      frontText: frontText,
      backText: backText,
    );
  }

  Future<void> updateFlashcard({
    required DatabaseFlashcard flashcard,
    required String frontText,
    required String backText,
  }) async {
    if (!_initialized) throw FcServiceNotInitialized();

    await LocalDbController().updateFlashcard(
      flashcard: flashcard,
      frontText: frontText,
      backText: backText,
    );
  }

  List<DatabaseFlashcardSet> get fcSets =>
      _initialized ? _flashcardSets! : throw FcServiceNotInitialized();
}

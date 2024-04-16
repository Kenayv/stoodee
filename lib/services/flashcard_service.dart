import 'dart:developer' as dart_developer;
import 'dart:math';

import 'package:stoodee/services/local_crud/local_database_service/database_flashcard.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';

import 'local_crud/crud_exceptions.dart';

class FlashcardsService {
  late List<DatabaseFlashcardSet>? _flashcardSets;
  bool _initialized = false;

  //FlashcardsService should be only used via singleton //
  static final FlashcardsService _shared = FlashcardsService._sharedInstance();
  factory FlashcardsService() => _shared;
  FlashcardsService._sharedInstance();
  //FlashcardsService should be only used via singleton //

  DatabaseFlashcard getRandFcFromList({
    required List<DatabaseFlashcard> fcList,
    bool canReturnCardBeforeDisplayDate = false,
  }) {
    if (!_initialized) throw FcServiceNotInitialized();
    if (fcList.isEmpty) throw FlashcardListEmpty();

    int randIndex = Random().nextInt(fcList.length);

    if (!canReturnCardBeforeDisplayDate) {
      while (fcList[randIndex].displayAfterDate.isAfter(DateTime.now())) {
        randIndex = Random().nextInt(fcList.length);
      }
    }

    return fcList[randIndex];
  }

  Future<void> incrFcsCompletedToday() async {
    final user = LocalDbController().currentUser;
    await LocalDbController().incrFcsCompletedToday(
      user: user,
    );
  }

  Future<void> reloadFlashcardSets() async {
    _flashcardSets = null;

    _flashcardSets = await LocalDbController().getUserFlashcardSets(
      user: LocalDbController().currentUser,
    );
  }

  Future<List<DatabaseFlashcardSet>> getFlashcardSets() async {
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

    dart_developer.log(debugLogStart + debugLogFlashcardSets + debugLogEnd);

    return _flashcardSets!;
  }

  Future<List<DatabaseFlashcard>> loadFlashcardsFromSet({
    required DatabaseFlashcardSet fcSet,
  }) async {
    final flashcards = await LocalDbController().getFlashcardsFromSet(
      fcSet: fcSet,
    );

    //FIXME: debug log
    String debugLogStart = "[START] loading Flashcards [START]\n\n";
    String debugLogFlashcards = "$flashcards\n\n";
    String debugLogEnd = "[END] loading Flashcards [END]\n.";

    dart_developer.log(debugLogStart + debugLogFlashcards + debugLogEnd);

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

  int get fcsCompletedToday => _initialized
      ? LocalDbController().currentUser.flashcardsCompletedToday
      : throw FcServiceNotInitialized();
}

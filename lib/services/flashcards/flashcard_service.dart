import 'dart:math';
import 'package:stoodee/services/flashcards/fc_difficulty.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/services/local_crud/crud_exceptions.dart';

class FlashcardsService {
  late List<FlashcardSet>? _flashcardSets;
  bool _initialized = false;

  //FlashcardsService should be only used via singleton //
  static final FlashcardsService _shared = FlashcardsService._sharedInstance();
  factory FlashcardsService() => _shared;
  FlashcardsService._sharedInstance();
  //FlashcardsService should be only used via singleton //

  Flashcard getRandFromList({
    required List<Flashcard> fcList,
    bool? mustBeActive,
  }) {
    if (!_initialized) throw FcServiceNotInitialized();
    if (fcList.isEmpty) throw FlashcardListEmpty();

    int randIndex = Random().nextInt(fcList.length);

    if (mustBeActive != null && mustBeActive) {
      while (fcList[randIndex].displayDate.isBefore(DateTime.now())) {
        randIndex = Random().nextInt(fcList.length);
      }
    }

    return fcList[randIndex];
  }

  Future<void> incrFcsCompleted() async {
    final user = LocalDbController().currentUser;

    if (!LocalDbController().isNullUser(user)) {
      await LocalDbController().incrUserFcsCompleted(user: user);
    }
  }

  Future<void> reloadFlashcardSets() async {
    _flashcardSets = await LocalDbController()
        .getUserFlashcardSets(user: LocalDbController().currentUser);
  }

  Future<List<FlashcardSet>> getFlashcardSets() async {
    if (!_initialized) {
      _flashcardSets = await LocalDbController()
          .getUserFlashcardSets(user: LocalDbController().currentUser);
      _initialized = true;
    }

    return _flashcardSets!;
  }

  Future<List<Flashcard>> loadFlashcardsFromSet({
    required FlashcardSet fcSet,
    required bool mustBeActive,
  }) async {
    final flashcards = await LocalDbController().getFlashcardsFromSet(
      fcSet: fcSet,
    );

    if (mustBeActive) {
      final now = DateTime.now();
      return flashcards.where((card) => now.isAfter(card.displayDate)).toList();
    }

    return flashcards;
  }

  Future<FlashcardSet> createFcSet({required String name}) async {
    if (!_initialized) throw FcServiceNotInitialized();

    final fcSet = await LocalDbController().createFcSet(
      owner: LocalDbController().currentUser,
      name: name,
    );

    _flashcardSets!.add(fcSet);
    return fcSet;
  }

  Future<void> removeFcSet(FlashcardSet fcSet) async {
    if (!_initialized) throw FcServiceNotInitialized();

    await LocalDbController().deleteFcSet(fcSet: fcSet);

    _flashcardSets!.removeWhere((fcSetToRemove) => fcSetToRemove == fcSet);
  }

  Future<void> renameFcSet({
    required FlashcardSet fcSet,
    required String name,
  }) async {
    if (!_initialized) throw FcServiceNotInitialized();

    await LocalDbController().updateFcSet(
      fcSet: fcSet,
      name: name,
    );

    fcSet.setName(name);
  }

  Future<void> removeFlashcard({
    required Flashcard flashcard,
  }) async {
    if (!_initialized) throw FcServiceNotInitialized();

    await LocalDbController().deleteFlashcard(flashcard: flashcard);
  }

  Future<Flashcard> createFlashcard({
    required FlashcardSet fcSet,
    required String frontText,
    required String backText,
  }) async {
    if (!_initialized) throw FcServiceNotInitialized();

    return await LocalDbController().createFlashcard(
      fcSet: fcSet,
      user: LocalDbController().currentUser,
      frontText: frontText,
      backText: backText,
    );
  }

  Future<void> updateFlashcard({
    required Flashcard flashcard,
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

  Future<void> calcFcDisplayDate({
    required Flashcard fc,
    required int newDifficulty,
  }) async {
    final newDisplayDate =
        calculateFcDisplayDate(cardDifficulty: newDifficulty);

    await LocalDbController().updateFcdifficulty(
      flashcard: fc,
      difficulty: newDifficulty,
    );
    await LocalDbController().updateFcDisplayDate(
      flashcard: fc,
      displayDate: newDisplayDate,
    );

    fc.setCardDifficulty(newDifficulty);
    fc.setDisplay(newDisplayDate);
  }
}

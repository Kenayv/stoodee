import 'package:stoodee/services/local_crud/flashcards_service/flashcard_set.dart';

class SetContainer {
  final FlashcardSet currentSet;
  final String name;

  SetContainer({required this.currentSet, required this.name});

  String getName() {
    return name;
  }

  FlashcardSet getSet() {
    return currentSet;
  }
}

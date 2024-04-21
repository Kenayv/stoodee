import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';

class SetContainer {
  final DatabaseFlashcardSet currentSet;
  final String name;

  SetContainer({required this.currentSet, required this.name});

  String getName() {
    return name;
  }

  DatabaseFlashcardSet getSet() {
    return currentSet;
  }
}

class AchievementTileContainer {
  final String name;
  final String path;
  final String desc;

  AchievementTileContainer(
      {required this.name, required this.path, required this.desc});
}

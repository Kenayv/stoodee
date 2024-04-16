import 'package:stoodee/services/local_crud/local_database_service/database_flashcard.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_task.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_user.dart';

class CloudUserData {
  final DatabaseUser user;
  final List<DatabaseTask> tasks;
  final List<DatabaseFlashcardSet> flashcardSets;
  final List<DatabaseFlashcard> flashcards;

  CloudUserData({
    required this.user,
    required this.tasks,
    required this.flashcardSets,
    required this.flashcards,
  });
}

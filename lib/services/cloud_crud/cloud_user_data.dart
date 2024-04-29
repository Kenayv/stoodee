import 'package:stoodee/services/local_crud/local_database_service/database_flashcard.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_task.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_user.dart';

class CloudUserData {
  final User user;
  final List<Task> tasks;
  final List<FlashcardSet> flashcardSets;
  final List<Flashcard> flashcards;

  CloudUserData({
    required this.user,
    required this.tasks,
    required this.flashcardSets,
    required this.flashcards,
  });

  @override
  String toString() {
    return 'CLOUD DATA:\n\n\n$user\n\n$tasks\n\n$flashcardSets\n\n$flashcards\n\n\n';
  }
}

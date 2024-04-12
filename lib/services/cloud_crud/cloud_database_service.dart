import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:stoodee/firebase_options.dart';
import 'package:stoodee/services/cloud_crud/cloud_exceptions.dart';
import 'package:stoodee/services/cloud_crud/consts.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_task.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_user.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class CloudDatabaseService {
  Future<void> createUser({required DatabaseUser user}) async {
    final nullUser = await LocalDbController().getNullUser();
    if (user == nullUser) throw NullUserException();

    final docUser = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(user.cloudId);

    //user.cloudId can be null. If Firestore instance created new id for user, assign it to dbuser
    if (user.cloudId == null) {
      await LocalDbController().setUserCloudId(
        user: user,
        cloudId: docUser.id,
      );
    }

    // check if user already exists in database and throw an error if it does
    if (await _docExists(docUser)) throw CloudUserAlreadyExists();

    await docUser.set(user.toJson());
  }

  Future<void> createTask({
    required DatabaseUser user,
    required DatabaseTask task,
  }) async {
    final nullUser = await LocalDbController().getNullUser();
    if (user == nullUser) throw NullUserException();

    final docTask = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(user.cloudId)
        .collection(tasksCollection)
        .doc(task.id.toString());

    // check if task already exists in database and throw an error if it does
    if (await _docExists(docTask)) throw CloudTaskAlreadyExists();

    await docTask.set(task.toJson());
  }

  Future<void> createFlashcardSet({
    required DatabaseUser user,
    required DatabaseFlashcardSet fcSet,
  }) async {
    final nullUser = await LocalDbController().getNullUser();
    if (user == nullUser) throw NullUserException();

    final docFcSet = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(user.cloudId)
        .collection(flashcardSetsCollection)
        .doc(fcSet.id.toString());

    // check if task already exists in database and throw an error if it does
    if (await _docExists(docFcSet)) throw CloudFlashcardSetAlreadyExists();

    await docFcSet.set(fcSet.toJson());
  }

  Future<void> createFlashcard({
    required DatabaseUser user,
    required DatabaseFlashcardSet fcSet,
    required DatabaseFlashcard flashcard,
  }) async {
    final nullUser = await LocalDbController().getNullUser();
    if (user == nullUser) throw NullUserException();

    final docFlashcard = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(user.cloudId)
        .collection(flashcardSetsCollection)
        .doc(fcSet.id.toString())
        .collection(flashcardsCollection)
        .doc(flashcard.id.toString());

    // check if task already exists in database and throw an error if it does
    if (await _docExists(docFlashcard)) throw CloudFlashcardSetAlreadyExists();

    await docFlashcard.set(flashcard.toJson());
  }

  Future<bool> _docExists(DocumentReference<Map<String, dynamic>> doc) async {
    final docSnapshot = await doc.get();
    return docSnapshot.exists;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stoodee/services/cloud_crud/cloud_exceptions.dart';
import 'package:stoodee/services/cloud_crud/consts.dart';
import 'package:stoodee/services/local_crud/crud_exceptions.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_task.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_user.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';

class CloudDatabaseService {
  Future<void> createUser({
    required DatabaseUser user,
  }) async {
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
    if (await _docExists(docFlashcard)) throw CloudFlashcardAlreadyExists();

    await docFlashcard.set(flashcard.toJson());
  }

  Future<void> deleteUser({
    required DatabaseUser user,
  }) async {
    final nullUser = await LocalDbController().getNullUser();
    if (user == nullUser) throw NullUserException();

    final docUser = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(user.cloudId);

    if (await _docExists(docUser) == false) throw CouldNotFindUser();

    await docUser.delete();
  }

  Future<void> deleteTask({
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

    if (await _docExists(docTask) == false) throw CouldNotFindTask();

    await docTask.delete();
  }

  Future<void> deleteFlashcardSet({
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

    if (await _docExists(docFcSet) == false) throw CouldNotFindCloudFcSet();

    await docFcSet.delete();
  }

  Future<void> deleteFlashcard({
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

    if (await _docExists(docFlashcard) == false) throw CouldNotFindCloudFcSet();

    await docFlashcard.delete();
  }

  Future<void> updateUser({
    required String cloudUserId,
    required DatabaseUser newUser,
  }) async {
    final nullUser = await LocalDbController().getNullUser();
    if (newUser == nullUser) throw NullUserException();

    final docUser =
        FirebaseFirestore.instance.collection(usersCollection).doc(cloudUserId);

    if (await _docExists(docUser) == false) throw CouldNotFindUser();

    await docUser.update(newUser.toJson());
  }

  Future<void> updateTask({
    required DatabaseUser user,
    required String cloudTaskId,
    required DatabaseTask newTask,
  }) async {
    final nullUser = await LocalDbController().getNullUser();
    if (user == nullUser) throw NullUserException();

    final docTask = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(user.cloudId)
        .collection(tasksCollection)
        .doc(cloudTaskId);

    if (await _docExists(docTask) == false) throw CouldNotFindTask();

    await docTask.update(newTask.toJson());
  }

  Future<void> updateFlashcardSet({
    required DatabaseUser user,
    required String cloudFcSetId,
    required DatabaseFlashcardSet newFcSet,
  }) async {
    final nullUser = await LocalDbController().getNullUser();
    if (user == nullUser) throw NullUserException();

    final docFcSet = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(user.cloudId)
        .collection(flashcardSetsCollection)
        .doc(cloudFcSetId);

    if (await _docExists(docFcSet) == false) throw CouldNotFindCloudFcSet();

    await docFcSet.update(newFcSet.toJson());
  }

  Future<void> updateFlashcard({
    required DatabaseUser user,
    required DatabaseFlashcardSet fcSet,
    required String cloudFcId,
    required DatabaseFlashcard newFlashcard,
  }) async {
    final nullUser = await LocalDbController().getNullUser();
    if (user == nullUser) throw NullUserException();

    final docFlashcard = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(user.cloudId)
        .collection(flashcardSetsCollection)
        .doc(fcSet.id.toString())
        .collection(flashcardsCollection)
        .doc(cloudFcId);

    if (await _docExists(docFlashcard) == false) throw CouldNotFindFlashCard();

    await docFlashcard.update(newFlashcard.toJson());
  }

  Future<bool> _docExists(DocumentReference<Map<String, dynamic>> doc) async {
    final docSnapshot = await doc.get();
    return docSnapshot.exists;
  }
}

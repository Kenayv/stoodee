import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stoodee/services/cloud_crud/cloud_exceptions.dart';
import 'package:stoodee/services/cloud_crud/cloud_user_data.dart';
import 'package:stoodee/services/cloud_crud/consts.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_task.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_user.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';

class CloudDbController {
  //CloudDatabaseController should be only used via singleton  //
  static final CloudDbController _shared = CloudDbController._sharedInstance();
  factory CloudDbController() => _shared;
  CloudDbController._sharedInstance();
  //CloudDatabaseController should be only used via singleton //

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  Future<String?> getUserCloudIdByEmail({required String email}) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(usersCollection)
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      return null;
    }
  }

  Future<User?> getUserOrNull({required String? cloudId}) async {
    if (cloudId == null) return null;

    final docUser =
        FirebaseFirestore.instance.collection(usersCollection).doc(cloudId);

    final docSnapshot = await docUser.get();

    if (!docSnapshot.exists) return null;

    final userData = docSnapshot.data()!;
    return User.fromRow(userData);
  }

  Future<void> saveAllToCloud({
    required User user,
  }) async {
    final batch = _firestore.batch();

    final fcSets = await LocalDbController().getUserFlashcardSets(user: user);
    final flashcards = await LocalDbController().getUserFlashcards(user: user);
    final tasks = await LocalDbController().getUserTasks(user: user);

    await _saveUserToBatch(user: user, batch: batch);

    for (final task in tasks) {
      await _saveTaskToBatch(user: user, task: task, batch: batch);
    }

    for (final fcSet in fcSets) {
      await _saveFlashcardSetToBatch(user: user, fcSet: fcSet, batch: batch);
    }

    for (final fc in flashcards) {
      await _saveFlashcardToBatch(user: user, flashcard: fc, batch: batch);
    }

    await _deleteObsoleteTasksFromBatch(user: user, batch: batch);
    await _deleteObsoleteFlashcardsFromBatch(user: user, batch: batch);
    await _deleteObsoleteFcSetsFromBatch(user: user, batch: batch);

    await batch.commit();
  }

  Future<void> _saveUserToBatch({
    required User user,
    required WriteBatch batch,
  }) async {
    final userDoc = _firestore.collection(usersCollection).doc(user.cloudId);

    if (user.cloudId == null) {
      await LocalDbController()
          .updateUserCloudId(user: user, cloudId: userDoc.id);
      user.setCloudId(userDoc.id);
    }

    if (await _docExists(userDoc) == false) {
      batch.set(userDoc, user.toJson());
    } else {
      batch.update(userDoc, user.toJson());
    }
  }

  Future<void> _saveFlashcardSetToBatch({
    required User user,
    required FlashcardSet fcSet,
    required WriteBatch batch,
  }) async {
    if (user.cloudId == null) throw NullCloudIdException();

    final fcSetDoc = _firestore
        .collection(usersCollection)
        .doc(user.cloudId)
        .collection(flashcardSetsCollection)
        .doc(fcSet.id.toString());

    if (await _docExists(fcSetDoc) == false) {
      batch.set(fcSetDoc, fcSet.toJson());
    } else {
      batch.update(fcSetDoc, fcSet.toJson());
    }
  }

  Future<void> _saveFlashcardToBatch({
    required User user,
    required Flashcard flashcard,
    required WriteBatch batch,
  }) async {
    if (user.cloudId == null) throw NullCloudIdException();

    final flashcardDoc = _firestore
        .collection(usersCollection)
        .doc(user.cloudId)
        .collection(flashcardsCollection)
        .doc(flashcard.id.toString());

    if (await _docExists(flashcardDoc) == false) {
      batch.set(flashcardDoc, flashcard.toJson());
    } else {
      batch.update(flashcardDoc, flashcard.toJson());
    }
  }

  Future<void> _saveTaskToBatch({
    required User user,
    required Task task,
    required WriteBatch batch,
  }) async {
    if (user.cloudId == null) throw NullCloudIdException();

    final taskDoc = _firestore
        .collection(usersCollection)
        .doc(user.cloudId)
        .collection(tasksCollection)
        .doc(task.id.toString());

    if (await _docExists(taskDoc) == false) {
      batch.set(taskDoc, task.toJson());
    } else {
      batch.update(taskDoc, task.toJson());
    }
  }

  Future<bool> _docExists(DocumentReference<Map<String, dynamic>> doc) async {
    final docSnapshot = await doc.get();
    return docSnapshot.exists;
  }

  Future<CloudUserData> loadAllFromCloud({required User user}) async {
    if (user.cloudId == null) throw NullCloudIdException();

    final userData = await _loadUserData(user);
    final tasks = await _loadTasks(user);
    final flashcardSets = await _loadFlashcardSets(user);
    final flashcards = await _loadFlashcards(user);

    return CloudUserData(
      user: userData,
      tasks: tasks,
      flashcardSets: flashcardSets,
      flashcards: flashcards,
    );
  }

  Future<User> _loadUserData(User user) async {
    final docUser = _firestore.collection(usersCollection).doc(user.cloudId);
    final docSnapshot = await docUser.get();

    if (docSnapshot.exists) {
      final userData = docSnapshot.data()!;
      return User.fromRow(userData);
    } else {
      throw CouldNotFindCloudUser();
    }
  }

  Future<List<Task>> _loadTasks(User user) async {
    if (user.cloudId == null) throw NullCloudIdException();

    final taskCollection = _firestore
        .collection(usersCollection)
        .doc(user.cloudId)
        .collection(tasksCollection);

    final querySnapshot = await taskCollection.get();

    return querySnapshot.docs.map((doc) {
      final taskData = doc.data();
      return Task.fromRow(taskData);
    }).toList();
  }

  Future<List<FlashcardSet>> _loadFlashcardSets(
    User user,
  ) async {
    if (user.cloudId == null) throw NullCloudIdException();

    final setsCollection = _firestore
        .collection(usersCollection)
        .doc(user.cloudId)
        .collection(flashcardSetsCollection);

    final querySnapshot = await setsCollection.get();

    return querySnapshot.docs.map((doc) {
      final setData = doc.data();
      return FlashcardSet.fromRow(setData);
    }).toList();
  }

  Future<List<Flashcard>> _loadFlashcards(User user) async {
    if (user.cloudId == null) throw NullCloudIdException();

    final setsCollection = _firestore
        .collection(usersCollection)
        .doc(user.cloudId)
        .collection(flashcardsCollection);

    final querySnapshot = await setsCollection.get();

    return querySnapshot.docs.map((doc) {
      final setData = doc.data();
      return Flashcard.fromRow(setData);
    }).toList();
  }

  Future<void> _deleteObsoleteTasksFromBatch({
    required User user,
    required WriteBatch batch,
  }) async {
    final firestoreObjectIds = await _getFirestoreTaskIds(user);
    final localTaskIds = await _getLocalDbTaskIds(user);

    // Identify obsolete object IDs.
    final obsoleteTaskIds =
        firestoreObjectIds.where((id) => !localTaskIds.contains(id));

    _deleteObjectsByIdList(
      batch: batch,
      user: user,
      collection: tasksCollection,
      idList: obsoleteTaskIds,
    );
  }

  Future<void> _deleteObsoleteFlashcardsFromBatch({
    required User user,
    required WriteBatch batch,
  }) async {
    final firestoreFlashcardIds = await _getFirestoreFlashcardIds(user);
    final localFlashcardIds = await _getLocalDbFlashcardIds(user);

    // Identify obsolete object IDs.
    final obsoleteFlashcardIds =
        firestoreFlashcardIds.where((id) => !localFlashcardIds.contains(id));

    _deleteObjectsByIdList(
      batch: batch,
      user: user,
      collection: flashcardsCollection,
      idList: obsoleteFlashcardIds,
    );
  }

  Future<void> _deleteObsoleteFcSetsFromBatch({
    required User user,
    required WriteBatch batch,
  }) async {
    final firestoreFlashcardSetIds = await _getFirestoreFcSetIds(user);
    final localFlashcardSetIds = await _getLocalDbFcSetIds(user);

    // Identify obsolete object IDs.
    final obsoleteFcSetsIds = firestoreFlashcardSetIds
        .where((id) => !localFlashcardSetIds.contains(id));

    _deleteObjectsByIdList(
      batch: batch,
      user: user,
      collection: flashcardSetsCollection,
      idList: obsoleteFcSetsIds,
    );
  }

  // Iterate over the obsolete object IDs and delete them from the batch.
  void _deleteObjectsByIdList({
    required WriteBatch batch,
    required User user,
    required String collection,
    required Iterable<String> idList,
  }) {
    for (final id in idList) {
      final docRef = _firestore
          .collection(usersCollection)
          .doc(user.cloudId)
          .collection(collection)
          .doc(id);

      batch.delete(docRef);
    }
  }

  Future<List<String>> _getFirestoreTaskIds(User user) async {
    if (user.cloudId == null) throw NullCloudIdException();

    final querySnapshot = await _firestore
        .collection(usersCollection)
        .doc(user.cloudId)
        .collection(tasksCollection)
        .get();

    return querySnapshot.docs.map((doc) => doc.id).toList();
  }

  Future<List<String>> _getFirestoreFlashcardIds(User user) async {
    if (user.cloudId == null) throw NullCloudIdException();

    final querySnapshot = await _firestore
        .collection(usersCollection)
        .doc(user.cloudId)
        .collection(flashcardsCollection)
        .get();

    return querySnapshot.docs.map((doc) => doc.id).toList();
  }

  Future<List<String>> _getFirestoreFcSetIds(User user) async {
    if (user.cloudId == null) throw NullCloudIdException();

    final querySnapshot = await _firestore
        .collection(usersCollection)
        .doc(user.cloudId)
        .collection(flashcardSetsCollection)
        .get();

    return querySnapshot.docs.map((doc) => doc.id).toList();
  }

  Future<List<String>> _getLocalDbTaskIds(User user) async {
    final tasks = await LocalDbController().getUserTasks(user: user);
    return tasks.map((task) => task.id.toString()).toList();
  }

  Future<List<String>> _getLocalDbFlashcardIds(User user) async {
    final flashcards = await LocalDbController().getUserFlashcards(user: user);
    return flashcards.map((flashcard) => flashcard.id.toString()).toList();
  }

  Future<List<String>> _getLocalDbFcSetIds(User user) async {
    final fcSets = await LocalDbController().getUserFlashcardSets(user: user);
    return fcSets.map((flashcardSet) => flashcardSet.id.toString()).toList();
  }
}

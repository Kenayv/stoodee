import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stoodee/services/cloud_crud/cloud_user_data.dart';
import 'package:stoodee/services/cloud_crud/consts.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_task.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_user.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';

class CloudDbController {
  //CloudDatabaseController should be only used via singleton //
  static final CloudDbController _shared = CloudDbController._sharedInstance();
  factory CloudDbController() => _shared;
  CloudDbController._sharedInstance();
  //CloudDatabaseController should be only used via singleton //

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  Future<DatabaseUser?> getUserOrNull({required String? cloudId}) async {
    if (cloudId == null) return null;

    final docUser =
        FirebaseFirestore.instance.collection(usersCollection).doc(cloudId);
    final docSnapshot = await docUser.get();

    if (!docSnapshot.exists) return null;

    final userData = docSnapshot.data()!;
    return DatabaseUser.fromRow(userData);
  }

  Future<void> saveAllToCloud({
    required DatabaseUser user,
  }) async {
    final batch = _firestore.batch();

    final fcSets = await LocalDbController().getUserFlashcardSets(user: user);
    final tasks = await LocalDbController().getUserTasks(user: user);

    await _saveUserToBatch(user: user, batch: batch);

    for (final task in tasks) {
      await _saveTaskToBatch(user: user, task: task, batch: batch);
    }

    for (final fcSet in fcSets) {
      await _saveFlashcardSetToBatch(user: user, fcSet: fcSet, batch: batch);

      final flashcards =
          await LocalDbController().getFlashcardsFromSet(fcSet: fcSet);

      for (final flashcard in flashcards) {
        await _saveFlashcardToBatch(
          user: user,
          fcSet: fcSet,
          flashcard: flashcard,
          batch: batch,
        );
      }
    }

    await batch.commit();
    await deleteObsoleteFromCloud(user: user);
  }

  Future<void> _saveUserToBatch({
    required DatabaseUser user,
    required WriteBatch batch,
  }) async {
    final userDoc = _firestore.collection(usersCollection).doc(user.cloudId);

    if (user.cloudId == null) {
      LocalDbController().setUserCloudId(user: user, cloudId: userDoc.id);
    }
    if (await _docExists(userDoc) == false) {
      batch.set(userDoc, user.toJson());
    } else {
      batch.update(userDoc, user.toJson());
    }
  }

  Future<void> _saveFlashcardSetToBatch({
    required DatabaseUser user,
    required DatabaseFlashcardSet fcSet,
    required WriteBatch batch,
  }) async {
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
    required DatabaseUser user,
    required DatabaseFlashcardSet fcSet,
    required DatabaseFlashcard flashcard,
    required WriteBatch batch,
  }) async {
    final flashcardDoc = _firestore
        .collection(usersCollection)
        .doc(user.cloudId)
        .collection(flashcardSetsCollection)
        .doc(fcSet.id.toString())
        .collection(flashcardsCollection)
        .doc(flashcard.id.toString());

    if (await _docExists(flashcardDoc) == false) {
      batch.set(flashcardDoc, flashcard.toJson());
    } else {
      batch.update(flashcardDoc, flashcard.toJson());
    }
  }

  Future<void> _saveTaskToBatch({
    required DatabaseUser user,
    required DatabaseTask task,
    required WriteBatch batch,
  }) async {
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

  Future<CloudUserData> loadAllFromCloud({required DatabaseUser user}) async {
    try {
      final userData = await loadUserData(user);
      final tasks = await loadTasks(user);
      final flashcardSets = await loadFlashcardSets(user);
      final flashcards = await loadFlashcards(user, flashcardSets);

      return CloudUserData(
        user: userData,
        tasks: tasks,
        flashcardSets: flashcardSets,
        flashcards: flashcards,
      );
    } catch (e) {
      print("Error loading data from cloud: $e");
      rethrow;
    }
  }

  Future<DatabaseUser> loadUserData(DatabaseUser user) async {
    final docUser = _firestore.collection('users').doc(user.cloudId);
    final docSnapshot = await docUser.get();

    if (docSnapshot.exists) {
      final userData = docSnapshot.data()!;
      return DatabaseUser.fromRow(userData);
    } else {
      throw Exception("User data not found in Firestore");
    }
  }

  Future<List<DatabaseTask>> loadTasks(DatabaseUser user) async {
    final tasksCollection =
        _firestore.collection('users').doc(user.cloudId).collection('tasks');
    final querySnapshot = await tasksCollection.get();

    return querySnapshot.docs.map((doc) {
      final taskData = doc.data();
      return DatabaseTask.fromRow(taskData);
    }).toList();
  }

  Future<List<DatabaseFlashcardSet>> loadFlashcardSets(
      DatabaseUser user) async {
    final setsCollection = _firestore
        .collection('users')
        .doc(user.cloudId)
        .collection('flashcard_sets');
    final querySnapshot = await setsCollection.get();

    return querySnapshot.docs.map((doc) {
      final setData = doc.data();
      return DatabaseFlashcardSet.fromRow(setData);
    }).toList();
  }

  Future<List<DatabaseFlashcard>> loadFlashcards(
    DatabaseUser user,
    List<DatabaseFlashcardSet> flashcardSets,
  ) async {
    final List<DatabaseFlashcard> flashcards = [];

    for (final fcSet in flashcardSets) {
      final flashcardsCollection = _firestore
          .collection('users')
          .doc(user.cloudId)
          .collection('flashcard_sets')
          .doc(fcSet.id.toString())
          .collection('flashcards');

      final querySnapshot = await flashcardsCollection.get();
      final fcSetFlashcards = querySnapshot.docs.map((doc) {
        final flashcardData = doc.data();
        return DatabaseFlashcard.fromRow(flashcardData);
      }).toList();

      flashcards.addAll(fcSetFlashcards);
    }

    return flashcards;
  }

  Future<void> deleteObsoleteFromCloud({
    required DatabaseUser user,
  }) async {
    final cloudUserData = await loadAllFromCloud(user: user);

    final tasks = await LocalDbController().getUserTasks(user: user);
    final flashcards = await LocalDbController().getUserFlashcards(user: user);
    final flashcardSets =
        await LocalDbController().getUserFlashcardSets(user: user);

    // Identify obsolete tasks
    final obsoleteTasks = cloudUserData.tasks.where((cloudTask) {
      return tasks.any((localTask) => localTask.id == cloudTask.id);
    }).toList();

    // Identify obsolete flashcard sets
    final obsoleteFlashcardSets = cloudUserData.flashcardSets.where((cloudSet) {
      return flashcardSets.any((localSet) => localSet.id == cloudSet.id);
    }).toList();

    // Identify obsolete flashcards
    final obsoleteFlashcards = cloudUserData.flashcards.where((cloudFlashcard) {
      return flashcards
          .any((localFlashcard) => localFlashcard.id == cloudFlashcard.id);
    }).toList();

    // Delete obsolete tasks
    await Future.forEach(obsoleteTasks, (task) async {
      final taskDoc = FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(user.cloudId)
          .collection(tasksCollection)
          .doc(task.id.toString());
      await taskDoc.delete();
    });

    // Delete obsolete flashcard sets
    await Future.forEach(obsoleteFlashcardSets, (fcSet) async {
      final fcSetDoc = FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(user.cloudId)
          .collection(flashcardSetsCollection)
          .doc(fcSet.id.toString());
      await fcSetDoc.delete();
    });

    // Delete obsolete flashcards
    await Future.forEach(obsoleteFlashcards, (flashcard) async {
      final flashcardDoc = FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(user.cloudId)
          .collection(flashcardSetsCollection)
          .doc(flashcard.flashcardSetId.toString())
          .collection(flashcardsCollection)
          .doc(flashcard.id.toString());
      await flashcardDoc.delete();
    });
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:stoodee/firebase_options.dart';
import 'package:stoodee/services/auth/auth_user.dart';
import 'package:stoodee/services/auth/auth_provider.dart';
import 'package:stoodee/services/auth/auth_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:stoodee/services/crud/local_database_service/local_database_controller.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (currentUser != null) {
        LocalDbController().createOrLoginUser(email: email);
        return currentUser!;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw WeakPasswordAuthException();
        case 'email-already-in-use':
          throw EmailAlreadyInUseAuthException();
        case 'invalid-email':
          throw InvalidEmailAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (currentUser != null) {
        LocalDbController().createOrLoginUser(email: email);
        return currentUser!;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
        case 'invalid-email':
          throw InvalidCredentialsAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
      LocalDbController().setUser(await LocalDbController().getNullUser());
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}

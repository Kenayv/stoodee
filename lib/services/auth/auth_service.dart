import 'package:stoodee/services/auth/firebase_auth_provider.dart';
import 'package:stoodee/services/auth/auth_provider.dart';
import 'package:stoodee/services/auth/auth_user.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    await LocalDbController().createOrLoginAndSetUser(email: email);
    return await provider.createUser(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    await LocalDbController().createOrLoginAndSetUser(email: email);
    return await provider.logIn(email: email, password: password);
  }

  @override
  Future<void> logOut() async {
    LocalDbController().setCurrentUser(await LocalDbController().getNullUser());
    await provider.logOut();
  }

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> init() => provider.init();
}

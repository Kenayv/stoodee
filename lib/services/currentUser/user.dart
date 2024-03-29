import 'package:stoodee/services/crud/local_database_service/database_user.dart';
import 'package:stoodee/services/crud/local_database_service/local_database_controller.dart';

class CurrentUser {
  DatabaseUser? _currentUser;

  //Database Service should be only used via singleton //
  static final CurrentUser _shared = CurrentUser._sharedInstance();
  factory CurrentUser() => _shared;
  CurrentUser._sharedInstance();
  //Database Service should be only used via singleton //

  void setUser(DatabaseUser user) {
    _currentUser = user;
  }

  Future<void> init() async {
    setUser(await LocalDbController().nullUser);
  }

  DatabaseUser? get currentUser => _currentUser;
}

import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:stoodee/services/auth/auth_service.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/services/router/go_router_service.dart';
import 'package:stoodee/services/shared_prefs/shared_prefs.dart';

//FIXME ta funkcja ma być brzydka, logy też żeby fajnie się w konsolce pokazywały
void ___debuglogDataAfterInit___() {
  String debugLogStart = '[START] Debug log After Init [START]\n\n';

  String debugLog1 =
      'Initialized [sharedPrefs] with values:\n   remember has seen intro = [${SharedPrefs().rememberHasSeenIntro}]\n   remember Login Data = [${SharedPrefs().rememberLoginData}]\n\n\n';

  String debugLog2 =
      'Initialized AuthService with values:\n   Current user = [${AuthService.firebase().currentUser ?? 'null'}]\n\n\n';

  String debugLog3 =
      'Initialized localdb with values:\n   Current user = [${LocalDbController().currentUser.toString()}]\n\n';

  String debugLogEnd = '[END] Debug log After Init [END]\n.';

  log(debugLogStart + debugLog1 + debugLog2 + debugLog3 + debugLogEnd);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApp();

  ___debuglogDataAfterInit___();

  runApp(const MyApp());
}

Future<void> initApp() async {
  await SharedPrefs().init();
  await AuthService.firebase().init();

  // ugly ass code, idk if it should be there
  if (!SharedPrefs().rememberLoginData &&
      AuthService.firebase().currentUser != null) {
    await AuthService.firebase().logOut();
  }

  await LocalDbController().init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouterService,
    );
  }
}

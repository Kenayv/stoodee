import 'package:flutter/material.dart';
import 'package:stoodee/services/auth/auth_service.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/services/router/go_router_service.dart';
import 'package:stoodee/services/shared_prefs/shared_prefs.dart';
import 'package:stoodee/services/local_crud/local_database_service/consts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApp();

  debug___Print___info(
    sharedprefs: true,
    authService: true,
    localDbUser: true,
  );

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

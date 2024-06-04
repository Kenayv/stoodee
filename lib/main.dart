import 'package:flutter/material.dart';
import 'package:stoodee/services/auth/auth_service.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/services/router/go_router_service.dart';
import 'package:stoodee/services/shared_prefs/shared_prefs.dart';
import 'package:stoodee/utilities/theme/theme.dart';

Future<void> initApp() async {
  await SharedPrefs().init();
  await AuthService.firebase().init();

  if (!SharedPrefs().rememberLoginData &&
      AuthService.firebase().currentUser != null) {
    await AuthService.firebase().logOut();
  }

  await LocalDbController().init();

  if (SharedPrefs().prefferedTheme == SharedPrefs.lightTheme) {
    usertheme = whitetheme;
  } else {
    usertheme = blacktheme;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouterService,
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApp();

  runApp(const MyApp());
}

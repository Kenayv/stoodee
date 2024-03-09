import 'package:flutter/material.dart';
import 'package:stoodee/services/auth/auth_service.dart';
import 'package:stoodee/services/router/go_router_service.dart';

void main() async {
  await debugInitApp();
  runApp(const MyApp());
}

//FIXME: CREATED FOR DEBUG
Future<void> debugInitApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.firebase().initialize();
  if (AuthService.firebase().currentUser != null) {
    await AuthService.firebase().logOut();
  }
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

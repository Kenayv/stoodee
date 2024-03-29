import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stoodee/services/auth/auth_service.dart';
import 'package:stoodee/services/crud/flashcards_service/flashcard_service.dart';
import 'package:stoodee/services/crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/services/router/go_router_service.dart';
import 'package:stoodee/services/crud/todo_service/todo_service.dart';

void main() async {
  await initApp();
  runApp(const MyApp());
}

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDbController().init();
  await AuthService.firebase().initialize();

  //FIXME: debug log
  log(LocalDbController().currentUser.toString());

  //FIXME: LOGOUT CREATED FOR DEBUG
  if (AuthService.firebase().currentUser != null) {
    await AuthService.firebase().logOut();
  }

  await TodoService().init();
  await FlashcardService().init();
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

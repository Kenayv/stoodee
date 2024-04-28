import 'package:flutter/material.dart';
import 'package:stoodee/services/router/route_functions.dart';
import 'package:stoodee/services/shared_prefs/shared_prefs.dart';
import 'package:stoodee/utilities/theme/theme.dart';

class StartingPage extends StatefulWidget {
  const StartingPage({super.key, required this.title});
  final String title;

  @override
  State<StartingPage> createState() => _StartingPage();
}

class _StartingPage extends State<StartingPage> {
  @override
  void initState() {
    super.initState();

    if (!SharedPrefs().rememberHasSeenIntro) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => goRouterToIntro(context),
      );

      //it runs a function after last frame of build is finished
    } else if (SharedPrefs().rememberLoginData) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => goRouterToMain(context),
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => goRouterToLogin(context),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => goRouterToIntro(context),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: usertheme.backgroundColor,
      );
}

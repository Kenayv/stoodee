import 'package:flutter/material.dart';
import '../services/shared_prefs/shared_prefs.dart';
import '../services/router/route_functions.dart';



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


    if(!SharedPrefs().rememberHasSeenIntro){
      WidgetsBinding.instance.addPostFrameCallback((_) => goRouterToIntro(context));
      //yeah wtf does that mean, it runs a function after last frame of build is finished


    }
    else
    if (SharedPrefs().rememberLoginData) {
      WidgetsBinding.instance.addPostFrameCallback((_) => goRouterToMain(context));
    }
    else{
      WidgetsBinding.instance.addPostFrameCallback((_) => goRouterToLogin(context));
    }






  }



  @override
  Widget build(BuildContext context) {

    return const Scaffold(
    );
  }
}

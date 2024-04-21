import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:stoodee/services/cloud_crud/cloud_exceptions.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_user.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/utilities/containers.dart';
import 'package:stoodee/utilities/globals.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({
    super.key,
  });

  @override
  State<AchievementsPage> createState() => _AchievementsPage();
}

class _AchievementsPage extends State<AchievementsPage> {
  int pageIndex = 4; //FIXME: NOT USED????
  List<Widget> obtainedAchievements = [];

  void initAchivs() {
    // this function should check which achievements user had obtained.
    //FIXME: DEBUG DEBUG DEBUG
    for (Widget achievement in getUserAchievements(
      LocalDbController().currentUser,
    )) {
      obtainedAchievements.add(achievement);
    }
  }

  @override
  void initState() {
    initAchivs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 3,
          children: obtainedAchievements,
        ),
      ),
    );
  }
}

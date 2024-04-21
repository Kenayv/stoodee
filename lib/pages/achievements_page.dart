import 'package:flutter/material.dart';
import 'package:stoodee/utilities/pages_widgets/achievement_widgets.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPage();
}

class _AchievementsPage extends State<AchievementsPage> {
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
          children: getUserAchievementTiles(
            LocalDbController().currentUser,
          ),
        ),
      ),
    );
  }
}

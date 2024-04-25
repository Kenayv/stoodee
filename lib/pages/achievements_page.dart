import 'package:flutter/material.dart';
import 'package:stoodee/utilities/page_utilities/achievement_widgets.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPage();
}

class _AchievementsPage extends State<AchievementsPage> {
  @override
  Widget build(BuildContext context) {
    final userAchivs = getUserAchievementTiles(
      LocalDbController().currentUser,
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You have unlocked ${userAchivs.length} out of 12 achievements!',
              style: const TextStyle(fontSize: 13),
            ),
            Expanded(
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                children: userAchivs,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

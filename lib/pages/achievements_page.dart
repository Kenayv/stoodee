import 'package:flutter/material.dart';
import 'package:stoodee/services/cloud_crud/cloud_exceptions.dart';
import 'package:stoodee/utilities/page_utilities_and_widgets/achievement_widgets.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/utilities/theme/theme.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPage();
}

class _AchievementsPage extends State<AchievementsPage> {
  @override
  Widget build(BuildContext context) {
    try {
      final userAchivs = getUserAchievementTiles(
        LocalDbController().currentUser,
      );

      return Scaffold(
        backgroundColor: usertheme.backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You have unlocked ${userAchivs.length} out of 12 achievements!',
                style: TextStyle(fontSize: 13, color: usertheme.textColor),
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
    } on NullUserException {
      return Scaffold(
        backgroundColor: usertheme.backgroundColor,
        body: const Center(
          child: Text("log-in to see achievements"),
        ),
      );
    }
  }
}

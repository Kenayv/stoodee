import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:stoodee/services/achievements/const_achievements.dart';
import 'package:stoodee/services/cloud_crud/cloud_exceptions.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_user.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/utilities/theme/theme.dart';

class AchievementTileContainer {
  final String name;
  final String path;
  final String desc;

  AchievementTileContainer({
    required this.name,
    required this.path,
    required this.desc,
  });
}

class AchievementTile extends StatelessWidget {
  const AchievementTile({
    super.key,
    required this.name,
    required this.path,
    required this.desc,
  });
  final String name;
  final String path;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go(
          "/Achievements/dialog",
          extra: AchievementTileContainer(
            name: name,
            path: path,
            desc: desc,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: usertheme.analogousColor,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: usertheme.basicShaddow,
                blurRadius: 1,
                offset: const Offset(1, 2),
              )
            ]),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Svg(path),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<AchievementTile> getUserAchievementTiles(DatabaseUser user) {
  if (LocalDbController().isNullUser(user)) throw NullUserException();

  final totaluserTasks = user.totalTasksCompleted;
  final totaluserFlashcards = user.totalFlashcardsCompleted;
  final userStreakHighscore = user.streakHighscore;

  final List<AchievementTile> userAchivs = [];

  if (totaluserTasks >= 1) userAchivs.add(woodTaskAch);
  if (totaluserTasks >= 5) userAchivs.add(copperTaskAch);
  if (totaluserTasks >= 20) userAchivs.add(silverTaskAch);
  if (totaluserTasks >= 50) userAchivs.add(goldTaskAch);

  if (totaluserFlashcards >= 1) userAchivs.add(woodFcAch);
  if (totaluserFlashcards >= 10) userAchivs.add(copperFcAch);
  if (totaluserFlashcards >= 50) userAchivs.add(silverFcAch);
  if (totaluserFlashcards >= 250) userAchivs.add(goldTaskAch);

  if (userStreakHighscore >= 1) userAchivs.add(woodStreakAch);
  if (userStreakHighscore >= 3) userAchivs.add(copperStreakAch);
  if (userStreakHighscore >= 7) userAchivs.add(silverStreakAch);
  if (userStreakHighscore >= 14) userAchivs.add(goldStreakAch);

  return userAchivs;
}

import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:flutter/material.dart';
import 'package:stoodee/utilities/globals.dart';

Container achievementTile({required String name, required String path}) {
  return Container(
    decoration: BoxDecoration(
      color: primaryAppColor.withOpacity(0.5),
      borderRadius: const BorderRadius.all(Radius.circular(16)),
    ),
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
  );
}

List<Widget> allAchievements = [
  achievementTile(name: "WoodTask", path: "lib/assets/wood_tasks.svg"),
  achievementTile(name: "CopperTask", path: "lib/assets/copper_tasks.svg"),
  achievementTile(name: "SilverTask", path: "lib/assets/silver_tasks.svg"),
  achievementTile(name: "GoldTask", path: "lib/assets/gold_tasks.svg"),
  //
  achievementTile(name: "WoodFc", path: "lib/assets/wood_flashcards.svg"),
  achievementTile(name: "CopperFc", path: "lib/assets/copper_flashcards.svg"),
  achievementTile(name: "SilverFc", path: "lib/assets/silver_flashcards.svg"),
  achievementTile(name: "GoldFc", path: "lib/assets/gold_flashcards.svg"),
  //
  achievementTile(name: "WoodRush", path: "lib/assets/wood_rush.svg"),
  achievementTile(name: "CopperRush", path: "lib/assets/copper_rush.svg"),
  achievementTile(name: "SilverRush", path: "lib/assets/silver_rush.svg"),
  achievementTile(name: "GoldRush", path: "lib/assets/gold_rush.svg"),
  //
  achievementTile(name: "WoodStreak", path: "lib/assets/wood_streak.svg"),
  achievementTile(name: "CopperSteak", path: "lib/assets/copper_streak.svg"),
  achievementTile(name: "SilverStreak", path: "lib/assets/silver_streak.svg"),
  achievementTile(name: "GoldStreak", path: "lib/assets/gold_streak.svg"),
];

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
    for (Widget achievement in allAchievements) {
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

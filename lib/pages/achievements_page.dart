import 'package:flutter/material.dart';
import 'package:stoodee/utilities/reusables/achievement_tile.dart';

/*

Container achievementTile({required String name, required String path}) {
  return Container(
    decoration: const BoxDecoration(
      color: analogusColor,
      borderRadius: BorderRadius.all(Radius.circular(16)),
      boxShadow: [
        BoxShadow(
              color: Color.fromRGBO(80, 80, 80, 1.0),
              blurRadius: 1,
              offset: Offset(1,2),
        )
      ]
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

 */

List<Widget> allAchievements = [
  const AchievementTile(
    name: "WoodTask",
    path: "lib/assets/wood_tasks.svg",
    desc: 'Ukończ 1 zadanie',
  ),
  const AchievementTile(
    name: "CopperTask",
    path: "lib/assets/copper_tasks.svg",
    desc: 'Ukończ 5 zadań',
  ),
  const AchievementTile(
    name: "SilverTask",
    path: "lib/assets/silver_tasks.svg",
    desc: 'Ukończ 20 zadań',
  ),
  const AchievementTile(
    name: "GoldTask",
    path: "lib/assets/gold_tasks.svg",
    desc: 'Ukończ 50 zadań',
  ),
  //
  const AchievementTile(
    name: "WoodFc",
    path: "lib/assets/wood_flashcards.svg",
    desc: 'Odgadnij 1 fiszkę',
  ),
  const AchievementTile(
    name: "CopperFc",
    path: "lib/assets/copper_flashcards.svg",
    desc: 'Odgadnij 10 fiszek',
  ),
  const AchievementTile(
    name: "SilverFc",
    path: "lib/assets/silver_flashcards.svg",
    desc: 'Odgadnij 50 fiszek',
  ),
  const AchievementTile(
    name: "GoldFc",
    path: "lib/assets/gold_flashcards.svg",
    desc: 'Odgadnij 250 fiszek',
  ),
  //
  const AchievementTile(
    name: "WoodRush",
    path: "lib/assets/wood_rush.svg",
    desc: 'Osiągnij rekord 5 Fiszki Rush',
  ),
  const AchievementTile(
    name: "CopperRush",
    path: "lib/assets/copper_rush.svg",
    desc: 'Osiągnij rekord 15 Fiszki Rush',
  ),
  const AchievementTile(
    name: "SilverRush",
    path: "lib/assets/silver_rush.svg",
    desc: 'Osiągnij rekord 25 Fiszki Rush',
  ),
  const AchievementTile(
    name: "GoldRush",
    path: "lib/assets/gold_rush.svg",
    desc: 'Osiągnij rekord 45 Fiszki Rush',
  ),
  //
  const AchievementTile(
    name: "WoodStreak",
    path: "lib/assets/wood_streak.svg",
    desc: 'Zdobądź 1-dniowy Streak',
  ),
  const AchievementTile(
    name: "CopperSteak",
    path: "lib/assets/copper_streak.svg",
    desc: 'Zdobądź 3-dniowy Streak',
  ),
  const AchievementTile(
    name: "SilverStreak",
    path: "lib/assets/silver_streak.svg",
    desc: 'Zdobądź 7-dniowy Streak',
  ),
  const AchievementTile(
    name: "GoldStreak",
    path: "lib/assets/gold_streak.svg",
    desc: 'Zdobądź 14-dniowy Streak',
  ),
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

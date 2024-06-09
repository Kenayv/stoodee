import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:stoodee/utilities/page_utilities_and_widgets/achievement_widgets.dart';

import '../../localization/locales.dart';


/*

const woodTaskAch = AchievementTile(
  name: "WoodTask",
  path: "lib/assets/wood_tasks.svg",
  desc: 'Complete 1 task',
);

const copperTaskAch = AchievementTile(
  name: "CopperTask",
  path: "lib/assets/copper_tasks.svg",
  desc: 'Complete 5 tasks',
);

const silverTaskAch = AchievementTile(
  name: "SilverTask",
  path: "lib/assets/silver_tasks.svg",
  desc: 'Complete 20 tasks',
);

const goldTaskAch = AchievementTile(
  name: "GoldTask",
  path: "lib/assets/gold_tasks.svg",
  desc: 'Complete 50 tasks',
);

const woodFcAch = AchievementTile(
  name: "WoodFc",
  path: "lib/assets/wood_flashcards.svg",
  desc: 'Finish 1 flashcard',
);

const copperFcAch = AchievementTile(
  name: "CopperFc",
  path: "lib/assets/copper_flashcards.svg",
  desc: 'Finish 10 Flashcards',
);

const silverFcAch = AchievementTile(
  name: "SilverFc",
  path: "lib/assets/silver_flashcards.svg",
  desc: 'Finish 50 Flashcards',
);

const goldFcAch = AchievementTile(
  name: "GoldFc",
  path: "lib/assets/gold_flashcards.svg",
  desc: 'Finish 250 Flashcards',
);

const woodRushAch = AchievementTile(
  name: "WoodRush",
  path: "lib/assets/wood_rush.svg",
  desc: 'Achieve a score of 5 in Flashcards Rush',
);

const copperRushAch = AchievementTile(
  name: "CopperRush",
  path: "lib/assets/copper_rush.svg",
  desc: 'Achieve a score of 15 in Flashcards Rush',
);

const silverRushAch = AchievementTile(
  name: "SilverRush",
  path: "lib/assets/silver_rush.svg",
  desc: 'Achieve a score of 25 in Flashcards Rush',
);

const goldRushAch = AchievementTile(
  name: "GoldRush",
  path: "lib/assets/gold_rush.svg",
  desc: 'Achieve a score of 45 in Flashcards Rush',
);

//

const woodStreakAch = AchievementTile(
  name: "WoodStreak",
  path: "lib/assets/wood_streak.svg",
  desc: 'Achieve a 1-day Streak',
);

const copperStreakAch = AchievementTile(
  name: "CopperStreak",
  path: "lib/assets/copper_streak.svg",
  desc: 'Achieve a 3-day Streak',
);

const silverStreakAch = AchievementTile(
  name: "SilverStreak",
  path: "lib/assets/silver_streak.svg",
  desc: 'Achieve a 7-day Streak',
);

const goldStreakAch = AchievementTile(
  name: "GoldStreak",
  path: "lib/assets/gold_streak.svg",
  desc: 'Achieve a 14-day Streak',
);



 */



AchievementTile evaluateWoodTaskAch(BuildContext context){


  AchievementTile evaluatedWoodTaskAch2 = AchievementTile(
    name: LocaleData.achWoodTaskName.getString(context),
    path: "lib/assets/wood_tasks.svg",
    desc: LocaleData.achWoodTaskDesc.getString(context),
  );
  return evaluatedWoodTaskAch2;

}



AchievementTile evaluateCopperTaskAch(BuildContext context) {
  return AchievementTile(
    name: LocaleData.achCopperTaskName.getString(context),
    path: "lib/assets/copper_tasks.svg",
    desc: LocaleData.achCopperTaskDesc.getString(context),
  );
}

AchievementTile evaluateSilverTaskAch(BuildContext context) {
  return AchievementTile(
    name: LocaleData.achSilverTaskName.getString(context),
    path: "lib/assets/silver_tasks.svg",
    desc: LocaleData.achSilverTaskDesc.getString(context),
  );
}

AchievementTile evaluateGoldTaskAch(BuildContext context) {
  return AchievementTile(
    name: LocaleData.achGoldTaskName.getString(context),
    path: "lib/assets/gold_tasks.svg",
    desc: LocaleData.achGoldTaskDesc.getString(context),
  );
}

AchievementTile evaluateWoodFcAch(BuildContext context) {
  return AchievementTile(
    name: LocaleData.achWoodFcName.getString(context),
    path: "lib/assets/wood_flashcards.svg",
    desc: LocaleData.achWoodFcDesc.getString(context),
  );
}

AchievementTile evaluateCopperFcAch(BuildContext context) {
  return AchievementTile(
    name: LocaleData.achCopperFcName.getString(context),
    path: "lib/assets/copper_flashcards.svg",
    desc: LocaleData.achCopperFcDesc.getString(context),
  );
}

AchievementTile evaluateSilverFcAch(BuildContext context) {
  return AchievementTile(
    name: LocaleData.achSilverFcName.getString(context),
    path: "lib/assets/silver_flashcards.svg",
    desc: LocaleData.achSilverFcDesc.getString(context),
  );
}

AchievementTile evaluateGoldFcAch(BuildContext context) {
  return AchievementTile(
    name: LocaleData.achGoldFcName.getString(context),
    path: "lib/assets/gold_flashcards.svg",
    desc: LocaleData.achGoldFcDesc.getString(context),
  );
}

AchievementTile evaluateWoodRushAch(BuildContext context) {
  return AchievementTile(
    name: LocaleData.achWoodRushName.getString(context),
    path: "lib/assets/wood_rush.svg",
    desc: LocaleData.achWoodRushDesc.getString(context),
  );
}

AchievementTile evaluateCopperRushAch(BuildContext context) {
  return AchievementTile(
    name: LocaleData.achCopperRushName.getString(context),
    path: "lib/assets/copper_rush.svg",
    desc: LocaleData.achCopperRushDesc.getString(context),
  );
}

AchievementTile evaluateSilverRushAch(BuildContext context) {
  return AchievementTile(
    name: LocaleData.achSilverRushName.getString(context),
    path: "lib/assets/silver_rush.svg",
    desc: LocaleData.achSilverRushDesc.getString(context),
  );
}

AchievementTile evaluateGoldRushAch(BuildContext context) {
  return AchievementTile(
    name: LocaleData.achGoldRushName.getString(context),
    path: "lib/assets/gold_rush.svg",
    desc: LocaleData.achGoldRushDesc.getString(context),
  );
}

AchievementTile evaluateWoodStreakAch(BuildContext context) {
  return AchievementTile(
    name: LocaleData.achWoodStreakName.getString(context),
    path: "lib/assets/wood_streak.svg",
    desc: LocaleData.achWoodStreakDesc.getString(context),
  );
}

AchievementTile evaluateCopperStreakAch(BuildContext context) {
  return AchievementTile(
    name: LocaleData.achCopperStreakName.getString(context),
    path: "lib/assets/copper_streak.svg",
    desc: LocaleData.achCopperStreakDesc.getString(context),
  );
}

AchievementTile evaluateSilverStreakAch(BuildContext context) {
  return AchievementTile(
    name: LocaleData.achSilverStreakName.getString(context),
    path: "lib/assets/silver_streak.svg",
    desc: LocaleData.achSilverStreakDesc.getString(context),
  );
}

AchievementTile evaluateGoldStreakAch(BuildContext context) {
  return AchievementTile(
    name: LocaleData.achGoldStreakName.getString(context),
    path: "lib/assets/gold_streak.svg",
    desc: LocaleData.achGoldStreakDesc.getString(context),
  );
}
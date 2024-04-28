// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stoodee/services/auth/auth_service.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_user.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/services/router/route_functions.dart';
import 'package:stoodee/services/shared_prefs/shared_prefs.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:stoodee/utilities/reusables/reusable_stoodee_button.dart';
import 'package:stoodee/utilities/theme/theme.dart';

StoodeeButton buildLoginOrLogoutButton(BuildContext context) {
  if (AuthService.firebase().currentUser == null) {
    return StoodeeButton(
        onPressed: () async {
          await SharedPrefs().setRememberLogin(value: false);
          goRouterToLogin(context);
        },
        child: Text("Log-in", style: buttonTextStyle));
  } else {
    return StoodeeButton(
      onPressed: () async {
        await SharedPrefs().setRememberLogin(value: false);
        await AuthService.firebase().logOut();
        final loggedOutUser = await LocalDbController().getNullUser();
        await LocalDbController().setCurrentUser(loggedOutUser);
        goRouterToLogin(context);
      },
      child: Text(
        "Log-out",
        style: buttonTextStyle,
      ),
    );
  }
}

Container buildStatsContainer(DatabaseUser user) {
  const String defaultStatString = 'Log-in to see stats!';

  String currentStreak = defaultStatString;

  String completedTasks = defaultStatString;
  String incompleteTasks = defaultStatString;
  String taskCompletion = defaultStatString;
  String fcRushHighscore = defaultStatString;
  String completedFlashcards = defaultStatString;
  String longestStreak = defaultStatString;

  if (!LocalDbController().isNullUser(user)) {
    currentStreak = currentStreak + currentStreak == '1' ? 'day' : 'days';
    longestStreak = longestStreak + longestStreak == '1' ? 'day' : 'days';
    taskCompletion = '$taskCompletion%';
  }

  if (!LocalDbController().isNullUser(user)) {
    currentStreak = user.currentDayStreak.toString();
    completedTasks = user.totalTasksCompleted.toString();
    incompleteTasks = user.totalIncompleteTasks.toString();

    if (user.totalTasksCompleted == 0) {
      taskCompletion = "00.00";
    } else if (user.totalIncompleteTasks == 0) {
      taskCompletion = "100.00";
    } else {
      taskCompletion = (user.totalTasksCompleted /
              (user.totalTasksCompleted + user.totalIncompleteTasks) *
              100)
          .toDouble()
          .toString();

      //Ensure that the format is "00.00"
      final divided = taskCompletion.split('.');
      if (divided[0].length < 2) {
        taskCompletion = '0$taskCompletion';
      }
      if (divided[1].length < 2) {
        taskCompletion = '${taskCompletion}0';
      }

      taskCompletion = taskCompletion.substring(0, 5);
    }
    fcRushHighscore = user.flashcardRushHighscore.toString();
    completedFlashcards = user.totalFlashcardsCompleted.toString();
    longestStreak = user.streakHighscore.toString();
  }

  return Container(
    padding: const EdgeInsets.all(5),
    width: double.infinity,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: usertheme.backgroundColor.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: usertheme.basicShaddow,
            offset: Offset(1, 1),
          )
        ]),
    child: Column(
      children: [
        buildStatItem('Completed flashcards', completedFlashcards),
        buildStatItem('Flashcards Rush highscore', fcRushHighscore),
        buildStatItem('Completed tasks', completedTasks),
        buildStatItem('Incomplete tasks', incompleteTasks),
        buildStatItem('Task completion rate', taskCompletion),
        buildStatItem('Current streak', currentStreak),
        buildStatItem('Longest streak', longestStreak),
      ],
    ),
  );
}

Padding buildStatItem(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 1.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$title:",
          style: TextStyle(fontSize: 16, color: usertheme.textColor),
        ),
        const Gap(20),
        Text(
          value,
          style: TextStyle(fontSize: 16, color: usertheme.textColor),
        ),
      ],
    ),
  );
}

Align buildProfilePic(BuildContext context) {
  double imgSize = MediaQuery.of(context).size.height * 0.15;
  return Align(
    alignment: Alignment.center,
    child: Image.asset(
      'lib/assets/BurnOutSorry.png',
      width: imgSize,
      height: imgSize,
    ),
  );
}

Text buildUsername(DatabaseUser user) {
  return Text(
    user.name,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: usertheme.textColor,
    ),
  );
}

Align buildSettingsButton({required void Function() onPressed}) {
  return Align(
    alignment: Alignment.topRight,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: StoodeeButton(
        onPressed: onPressed,
        child: const Icon(
          Icons.settings,
          color: Colors.white,
        ),
      ),
    ),
  );
}

StoodeeButton buildSyncWithCloudButton() {
  return StoodeeButton(
    child: const Icon(Icons.sync, color: Colors.white),
    onPressed: () async {
      await LocalDbController().syncWithCloud();
    },
  );
}

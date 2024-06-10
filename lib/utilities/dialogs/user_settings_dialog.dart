import 'package:flutter_localization/flutter_localization.dart';
import 'package:stoodee/localization/locales.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_user.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/services/shared_prefs/shared_prefs.dart';
import 'package:stoodee/utilities/dialogs/not_for_production_use/generic_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:stoodee/utilities/theme/theme.dart';

//Opens a new pop-up window allowing user to change user settings.
Future<void> showUserSettingsDialog({
  required BuildContext context,
  required User user,
}) {
  TextEditingController nameController = TextEditingController();
  TextEditingController fcGoalController = TextEditingController();
  TextEditingController taskGoalController = TextEditingController();
  String selectedTheme = SharedPrefs().preferredTheme;

  return genericInputDialog(
    context: context,
    contentText: LocaleData.accountSettingsInfo.getString(context),
    title: LocaleData.accountUserSettingsTitle.getString(context),
    inputs: [
      TextField(
        style: TextStyle(color: usertheme.textColor),
        controller: nameController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: usertheme.textColor.withOpacity(0.3)),
          hintText: LocaleData.accountNewUsername.getString(context),
        ),
      ),
      TextField(
        style: TextStyle(color: usertheme.textColor),
        keyboardType: TextInputType.number,
        controller: taskGoalController,
        decoration: InputDecoration(
          hintText: LocaleData.accountChangeWarning.getString(context),
          labelText: LocaleData.accountDailyTasksGoal.getString(context),
          hintStyle: TextStyle(
              fontSize: 14, color: usertheme.textColor.withOpacity(0.3)),
          labelStyle: TextStyle(
              fontSize: 14, color: usertheme.textColor.withOpacity(0.3)),
        ),
      ),
      TextField(
        style: TextStyle(color: usertheme.textColor),
        keyboardType: TextInputType.number,
        controller: fcGoalController,
        decoration: InputDecoration(
          hintText: LocaleData.accountChangeWarning.getString(context),
          labelText: LocaleData.accountDailyFlashcardGoal.getString(context),
          hintStyle: TextStyle(
              fontSize: 14, color: usertheme.textColor.withOpacity(0.3)),
          labelStyle: TextStyle(
              fontSize: 14, color: usertheme.textColor.withOpacity(0.3)),
        ),
      ),

      /*
      TextField(
        controller: userThemeController,
        decoration: const InputDecoration(
          labelText: 'Theme: \'dark_theme\' or \'light_theme\'',
          labelStyle: TextStyle(fontSize: 12),
        ),
      ),

       */
    ],
    selectmenus: DropdownButtonFormField<String>(
      style: TextStyle(color: usertheme.textColor),
      value: selectedTheme,
      decoration: InputDecoration(
        labelText: LocaleData.accountSelectTheme.getString(context),
        labelStyle: TextStyle(
            fontSize: 14, color: usertheme.textColor.withOpacity(0.3)),
      ),
      dropdownColor: usertheme.backgroundColor,
      items: [
        DropdownMenuItem(
          value: "dark_theme",
          child: Text(LocaleData.accountDarkTheme.getString(context)),
        ),
        DropdownMenuItem(
          value: "light_theme",
          child: Text(LocaleData.accountLightTheme.getString(context)),
        ),
      ],
      onChanged: (value) {
        if (value != null) {
          selectedTheme = value;
        }
      },
    ),
    function: () async {
      if (nameController.text.isNotEmpty) {
        final newName = nameController.text;
        await LocalDbController().updateUserName(
          user: user,
          name: newName,
        );
        user.setName(newName);
      }

      if (taskGoalController.text.isNotEmpty) {
        final newTaskGoal = int.parse(taskGoalController.text);
        await LocalDbController().updateUserDailyTaskGoal(
          user: user,
          taskGoal: newTaskGoal,
        );
        user.setDailyTaskGoal(newTaskGoal);
      }

      if (fcGoalController.text.isNotEmpty) {
        final newFcGoal = int.parse(fcGoalController.text);
        await LocalDbController().updateUserDailyFlashcardGoal(
          user: user,
          flashcardGoal: newFcGoal,
        );
        user.setDailyFlashcardsGoal(newFcGoal);
      }

      await SharedPrefs().setPreferredTheme(value: selectedTheme);
      reEvalTheme();
    },
  );
}

import 'package:stoodee/services/local_crud/local_database_service/database_user.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/services/shared_prefs/shared_prefs.dart';
import 'package:stoodee/utilities/dialogs/not_for_production_use/generic_input_dialog.dart';
import 'package:stoodee/utilities/snackbar/create_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:stoodee/utilities/theme/theme.dart';

//Opens a new pop-up window allowing user to change user settings.
Future<void> showUserSettingsDialog({
  required BuildContext context,
  required DatabaseUser user,
}) {
  TextEditingController nameController = TextEditingController();
  TextEditingController fcGoalController = TextEditingController();
  TextEditingController taskGoalController = TextEditingController();
  String selectedTheme = SharedPrefs().prefferedTheme;

  return genericInputDialog(
    context: context,
    contentText: 'Leave the fields below empty to keep them unchanged.',
    title: 'User settings',
    inputs: [
      TextField(
        style: TextStyle(color: usertheme.textColor),
        controller: nameController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: usertheme.textColor.withOpacity(0.3)),
          hintText: 'New username',
        ),
      ),
      TextField(
        //FIXME: placeholders should indicate previous value
        //sliders would work best
        style: TextStyle(color: usertheme.textColor),
        keyboardType: TextInputType.number,
        controller: taskGoalController,
        decoration: InputDecoration(
          hintText: 'warning! change resets today\'s progress.',
          labelText: 'daily tasks goal',
          hintStyle: TextStyle(
              fontSize: 14, color: usertheme.textColor.withOpacity(0.3)),
          labelStyle: TextStyle(
              fontSize: 14, color: usertheme.textColor.withOpacity(0.3)),
        ),
      ),
      TextField(
        style: TextStyle(color: usertheme.textColor),
        //FIXME: placeholders should indicate previous value
        //sliders would work best
        keyboardType: TextInputType.number,
        controller: fcGoalController,
        decoration: InputDecoration(
          hintText: 'warning! change resets today\'s progress.',
          labelText: 'daily flashcards goal',
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
        labelText: 'Select Theme',
        labelStyle: TextStyle(
            fontSize: 14, color: usertheme.textColor.withOpacity(0.3)),
      ),
      dropdownColor: usertheme.backgroundColor,
      items: const [
        DropdownMenuItem(
          value: "dark_theme",
          child: Text('Dark Theme'),
        ),
        DropdownMenuItem(
          value: "light_theme",
          child: Text('Light Theme'),
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
        await LocalDbController().setUserName(
          user: user,
          name: newName,
        );
        user.setName(newName);
      }

      if (taskGoalController.text.isNotEmpty) {
        final newTaskGoal = int.parse(taskGoalController.text);
        await LocalDbController().setUserDailyTaskGoal(
          user: user,
          taskGoal: newTaskGoal,
        );
        user.setDailyTaskGoal(newTaskGoal);
      }

      if (fcGoalController.text.isNotEmpty) {
        final newFcGoal = int.parse(fcGoalController.text);
        await LocalDbController().setUserDailyFlashcardGoal(
          user: user,
          flashcardGoal: newFcGoal,
        );
        user.setDailyFlashcardsGoal(newFcGoal);
      }

      await SharedPrefs().setPrefferedTheme(value: selectedTheme);
      reEvalTheme();
    },
  );
}

import 'package:stoodee/services/local_crud/local_database_service/database_user.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/services/shared_prefs/shared_prefs.dart';
import 'package:stoodee/utilities/dialogs/not_for_production_use/generic_input_dialog.dart';
import 'package:stoodee/utilities/snackbar/create_snackbar.dart';
import 'package:flutter/material.dart';

//Opens a new pop-up window allowing user to change user settings.
Future<void> showUserSettingsDialog({
  required BuildContext context,
  required DatabaseUser user,
}) {
  TextEditingController nameController = TextEditingController();
  TextEditingController fcGoalController = TextEditingController();
  TextEditingController taskGoalController = TextEditingController();
  TextEditingController userThemeController = TextEditingController();

  return genericInputDialog(
    context: context,
    title: 'User settings',
    inputs: [
      TextField(
        controller: nameController,
        decoration: const InputDecoration(
          hintText: 'New username',
        ),
      ),
      TextField(
        //FIXME: placeholders should indicate previous value
        //sliders would work best
        controller: taskGoalController,
        decoration: const InputDecoration(
          hintText: 'warning! change resets today\'s progress.',
          labelText: 'daily tasks goal',
          hintStyle: TextStyle(fontSize: 14),
          labelStyle: TextStyle(fontSize: 14),
        ),
      ),
      TextField(
        //FIXME: placeholders should indicate previous value
        //sliders would work best
        controller: fcGoalController,
        decoration: const InputDecoration(
          hintText: 'warning! change resets today\'s progress.',
          labelText: 'daily flashcards goal',
          hintStyle: TextStyle(fontSize: 14),
          labelStyle: TextStyle(fontSize: 14),
        ),
      ),
      TextField(
        controller: userThemeController,
        decoration: const InputDecoration(
          labelText: 'Theme: \'dark_theme\' or \'light_theme\'',
          labelStyle: TextStyle(fontSize: 12),
        ),
      ),
    ],
    function: () async {
      if (nameController.text.isNotEmpty &&
          fcGoalController.text.isNotEmpty &&
          taskGoalController.text.isNotEmpty &&
          userThemeController.text.isNotEmpty) {
        final newName = nameController.text;
        final newFcGoal = int.parse(fcGoalController.text);
        final newTaskGoal = int.parse(taskGoalController.text);
        final prefTheme = userThemeController.text;

        await LocalDbController().setUserName(user: user, name: newName);
        await LocalDbController()
            .setUserDailyTaskGoal(user: user, taskGoal: newTaskGoal);
        await LocalDbController()
            .setUserDailyFlashcardGoal(user: user, flashcardGoal: newFcGoal);

        await SharedPrefs().setPrefferedTheme(value: prefTheme);
        user.setName(newName);
        user.setDailyFlashcardsGoal(newFcGoal);
        user.setDailyTaskGoal(newTaskGoal);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          createErrorSnackbar("make sure all fields are filled"),
        );
      }
    },
  );
}

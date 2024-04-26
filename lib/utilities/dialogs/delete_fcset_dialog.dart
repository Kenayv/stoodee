import 'package:flutter/material.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/utilities/dialogs/not_for_production_use/generic_dialog.dart';

Future<bool> showDeleteFcSetDialog({
  required BuildContext context,
  required DatabaseFlashcardSet fcSet,
}) async {
  return await genericDialog(
        context: context,
        title: "Deleting ${fcSet.name}?",
        content: "are you sure you want to delete this set?",
        optionBuilder: () => {
          'Cancel': false,
          'Delete': true,
        },
      ) ??
      false;
}

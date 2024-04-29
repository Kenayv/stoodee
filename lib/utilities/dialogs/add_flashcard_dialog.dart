//Opens a new pop-up window allowing user to add a flashcard. Function invoked on (+) button press.

import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/services/flashcards/flashcard_service.dart';
import 'package:stoodee/utilities/dialogs/not_for_production_use/generic_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:stoodee/utilities/theme/theme.dart';

import '../snackbar/create_snackbar.dart';

Future<void> showAddFlashcardDialog(
    {required BuildContext context, required FlashcardSet fcSet}) {
  TextEditingController frontTextController = TextEditingController();
  TextEditingController backTextController = TextEditingController();
  return genericInputDialog(
    context: context,
    title: 'Add Flashcard',
    inputs: [
      TextField(
        style: TextStyle(color: usertheme.textColor),
        controller: frontTextController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: usertheme.textColor.withOpacity(0.3)),
          hintText: 'front text',
        ),
      ),
      TextField(
        style: TextStyle(color: usertheme.textColor),
        controller: backTextController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: usertheme.textColor.withOpacity(0.3)),
          hintText: 'back text',
        ),
      )
    ],
    function: () async {
      if (frontTextController.text.isNotEmpty &&
          backTextController.text.isNotEmpty) {
        await FlashcardsService().createFlashcard(
          fcSet: fcSet,
          frontText: frontTextController.text,
          backText: backTextController.text,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            createErrorSnackbar("make sure all fields are filled"));
      }
    },
  );
}

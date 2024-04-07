//Opens a new pop-up window allowing user to add a flashcard. Function invoked on (+) button press.

import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/services/flashcard_service.dart';
import 'package:stoodee/utilities/dialogs/not_for_production_use/generic_input_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showAddFlashcardDialog(
    {required BuildContext context, required DatabaseFlashcardSet fcSet}) {
  TextEditingController frontTextController = TextEditingController();
  TextEditingController backTextController = TextEditingController();
  return genericInputDialog(
    context: context,
    title: 'Add Flashcard',
    inputs: [
      TextField(
        controller: frontTextController,
        decoration: const InputDecoration(
          hintText: 'front text',
        ),
      ),
      TextField(
        controller: backTextController,
        decoration: const InputDecoration(
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
      }
    },
  );
}

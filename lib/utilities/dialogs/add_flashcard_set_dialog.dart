//Opens a new pop-up window allowing user to add a flashcardSet. Function invoked on (+) button press.
import 'package:stoodee/services/flashcards_service/flashcard_service.dart';
import 'package:stoodee/utilities/dialogs/generic_input_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showAddFcSetDialog({
  required BuildContext context,
}) {
  TextEditingController fcSetNameController = TextEditingController();
  return genericInputDialog(
    context: context,
    title: 'Add Flashcard Set',
    inputs: [
      TextField(
        controller: fcSetNameController,
        decoration: const InputDecoration(
          hintText: 'Set name',
        ),
      )
    ],
    function: () {
      if (fcSetNameController.text.isNotEmpty) {
        FlashcardService().addSet(name: fcSetNameController.text);
      }
    },
  );
}

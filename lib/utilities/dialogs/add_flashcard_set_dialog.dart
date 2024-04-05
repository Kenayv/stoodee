//Opens a new pop-up window allowing user to add a flashcardSet. Function invoked on (+) button press.
<<<<<<< HEAD
import 'package:stoodee/services/local_crud/flashcard_service.dart';
=======
>>>>>>> a968878df1f15000cf14772660c6c5d37a4335e3
import 'package:stoodee/utilities/dialogs/generic_input_dialog.dart';
import 'package:flutter/material.dart';

import '../../services/local_crud/flashcard_service.dart';

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
    function: () async {
      if (fcSetNameController.text.isNotEmpty) {
        await FlashcardService().createFcSet(name: fcSetNameController.text);
      }
    },
  );
}

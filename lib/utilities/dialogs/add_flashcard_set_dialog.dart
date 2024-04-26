//Opens a new pop-up window allowing user to add a flashcardSet. Function invoked on (+) button press.

import 'package:stoodee/utilities/dialogs/not_for_production_use/generic_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:stoodee/utilities/theme/theme.dart';

import '../../services/flashcards/flashcard_service.dart';

Future<void> showAddFcSetDialog({
  required BuildContext context,
}) {
  TextEditingController fcSetNameController = TextEditingController();
  return genericInputDialog(

    context: context,
    title: 'Add Flashcard Set',
    inputs: [
      TextField(
        style: TextStyle(color:usertheme.textColor),
        controller: fcSetNameController,
        decoration:  InputDecoration(

          hintStyle: TextStyle(color:usertheme.textColor.withOpacity(0.3)),
          hintText: 'Set name',
        ),
      )
    ],
    function: () async {
      if (fcSetNameController.text.isNotEmpty) {
        await FlashcardsService().createFcSet(name: fcSetNameController.text);
      }
    },
  );
}

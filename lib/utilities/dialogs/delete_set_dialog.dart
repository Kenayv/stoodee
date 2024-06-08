import 'package:flutter/material.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/utilities/snackbar/create_snackbar.dart';

import '../../services/flashcards/flashcard_service.dart';
import '../theme/theme.dart';

Future<dynamic> genericDeleteSetDialog({
  required BuildContext context,
  required List<FlashcardSet> fcsets,
  TextButton? additionalButton,
}) {
  FlashcardSet? selectedSet;

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Select a set to delete:"),
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            DropdownButton<FlashcardSet>(
              value: selectedSet,
              onChanged: (FlashcardSet? newValue) {
                setState(() {
                  selectedSet = newValue;
                });
              },
              items: fcsets.map((FlashcardSet set) {
                return DropdownMenuItem<FlashcardSet>(
                  value: set,
                  child: Text(set.name),
                );
              }).toList(),
            ),
          ]);
        }),
        actions: [
          TextButton(
            child: Text('Nevermind',
                style: TextStyle(color: usertheme.primaryAppColor)),
            onPressed: () {
              Navigator.of(context).pop(null);
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () async {
              try {
                await FlashcardsService().removeFcSet(selectedSet!);
              } on Exception {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        createErrorSnackbar("Please select a set >:("));
                  },
                );
              }
              WidgetsBinding.instance.addPostFrameCallback(
                (_) {
                  Navigator.of(context).pop(null);
                },
              );
            },
          )
        ],
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';

import '../../services/flashcard_service.dart';

Future<dynamic> genericDeleteSetDialog({
  required BuildContext context,
  required String title,
  required List<DatabaseFlashcardSet> fcsets,



  TextButton? additionalButton,
}) {
  DatabaseFlashcardSet? selectedSet;

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){
            return Column(
              mainAxisSize: MainAxisSize.min,
              children:[
                Text("Select a set to delete:"),
                DropdownButton<DatabaseFlashcardSet>(
                  value: selectedSet,
                  onChanged: (DatabaseFlashcardSet? newValue) {
                    setState(() {
                      selectedSet = newValue;
                    });
                  },
                  items: fcsets.map((DatabaseFlashcardSet set) {
                    return DropdownMenuItem<DatabaseFlashcardSet>(
                      value: set,
                      child: Text(set.name),
                    );
                  }).toList(),
                ),
              ]
            );
          }
        ),
        actions: [
          TextButton(
            child: const Text('No, dont delete'),
            onPressed: () {
              print("not deleted");
              Navigator.of(context).pop(null);
            },
          ),
          TextButton(
            child: const Text('Yes, delete'),
            onPressed: () async {
              await FlashcardsService().removeFcSet(selectedSet!);
              Navigator.of(context).pop(null);
            },
          )
        ],
      );
    },
  );
}

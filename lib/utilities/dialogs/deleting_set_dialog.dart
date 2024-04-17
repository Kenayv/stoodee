//DISCLAIMER: NOT USED FOR NOW, MAYBE LATER

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stoodee/services/flashcard_service.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';

import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/services/router/route_functions.dart';


class DeleteSetDialog extends StatefulWidget {
  final DatabaseFlashcardSet fcset;

  const DeleteSetDialog({
    super.key,
    required this.fcset,

  });

  @override
  State<DeleteSetDialog> createState() => _DeleteSetDialogState();
}

class _DeleteSetDialogState extends State<DeleteSetDialog> {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        shadowColor: Colors.black,
        elevation: 200,
        backgroundColor: Colors.white,
        title: Text("Deleting ${widget.fcset.name}"),
        content: Text('Are you sure you want to delete this set?'),
        actions: [

          TextButton(
            child: const Text('No, cancel'),
            onPressed: () {
              print("not deleted");
              setState(() {
                Navigator.of(context).pop(null);
              });

            },
          ),
          TextButton(
            child: const Text('Yes, delete'),
            onPressed: () async {
              print("deleted");
              await FlashcardsService().removeFcSet(widget.fcset);
              setState(() {

              });
              Navigator.of(context).pop(null);

            },
          ),
        ],



      ),
    );
  }
}

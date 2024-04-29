import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stoodee/services/flashcards/flashcard_service.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';

class DeleteSetDialog extends StatefulWidget {
  final FlashcardSet fcset;

  const DeleteSetDialog({
    super.key,
    required this.fcset,
    required FlashcardSet fcSet,
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
        content: const Text('Are you sure you want to delete this set?'),
        actions: [
          TextButton(
            child: const Text('cancel'),
            onPressed: () {
              Navigator.of(context).pop(null);
            },
          ),
          TextButton(
            child: const Text('delete'),
            onPressed: () async {
              await FlashcardsService().removeFcSet(widget.fcset);
            },
          ),
        ],
      ),
    );
  }
}

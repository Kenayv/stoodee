import 'package:flutter/material.dart';

Future<dynamic> genericInputDialog({
  required BuildContext context,
  required String title,
  required List<TextField> inputs,
  required Function()
      function, // Change the signature of the function to return a value
  TextButton? additionalButton,
}) {
  const voidWidget = SizedBox.shrink();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: inputs,
        ),
        actions: [
          additionalButton ?? voidWidget,
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(null);
            },
          ),
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(function());
            },
          )
        ],
      );
    },
  );
}

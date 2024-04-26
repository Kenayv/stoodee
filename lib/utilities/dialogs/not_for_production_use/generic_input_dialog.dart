import 'package:flutter/material.dart';
import 'package:stoodee/utilities/theme/theme.dart';

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
        backgroundColor: usertheme.backgroundColor,
        title: Text(title,style: TextStyle(color:usertheme.textColor),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: inputs,
        ),
        actions: [
          additionalButton ?? voidWidget,
          TextButton(
            child:  Text('Cancel',style: TextStyle(color: usertheme.textColor),),
            onPressed: () {
              Navigator.of(context).pop(null);
            },
          ),
          TextButton(
            child:  Text('OK',style: TextStyle(color: usertheme.textColor),),
            onPressed: () {
              Navigator.of(context).pop(function());
            },
          )
        ],
      );
    },
  );
}

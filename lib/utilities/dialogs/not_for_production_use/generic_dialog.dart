import 'package:flutter/material.dart';
import 'package:stoodee/utilities/theme/theme.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> genericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionBuilder,
}) async {
  final options = optionBuilder();
  return await showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: usertheme.backgroundColor,
        title: Text(title,style: TextStyle(color: usertheme.textColor)),
        content: Text(content,style: TextStyle(color: usertheme.textColor)),
        actions: options.keys.map(
          (optionTitle) {
            final T value = options[optionTitle]!;
            return TextButton(
              onPressed: () {
                if (value != null) {
                  Navigator.of(context).pop(value);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(optionTitle,style: TextStyle(color: usertheme.textColor),),
            );
          },
        ).toList(),
      );
    },
  );
}

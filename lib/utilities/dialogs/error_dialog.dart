import 'package:stoodee/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showErrorDialog(
  BuildContext context,
  String errorText,
) async {
  return await genericDialog<bool>(
        context: context,
        title: 'Error occured!',
        content: errorText,
        optionBuilder: () => {
          'OK': true,
        },
      ) ??
      false;
}

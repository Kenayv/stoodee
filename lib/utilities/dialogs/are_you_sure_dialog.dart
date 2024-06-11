//Opens a new pop-up window allowing user to add a task. Function invoked on (+) button press.
import 'package:flutter_localization/flutter_localization.dart';
import 'package:stoodee/localization/locales.dart';
import 'package:stoodee/utilities/dialogs/not_for_production_use/generic_input_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showDeleteFcDialog({
  required BuildContext context,
  required Function() fun,
}) {
  return genericInputDialog(
    context: context,
    title: LocaleData.fcreaderDialogAreYouSure.getString(context),
    inputs: [],
    function: () async {
      await fun();
    },
  );
}

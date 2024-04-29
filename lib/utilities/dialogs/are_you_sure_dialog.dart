//Opens a new pop-up window allowing user to add a task. Function invoked on (+) button press.
import 'package:stoodee/utilities/dialogs/not_for_production_use/generic_dialog.dart';
import 'package:stoodee/utilities/dialogs/not_for_production_use/generic_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:stoodee/utilities/theme/theme.dart';

import '../../services/todoTasks/todo_service.dart';

Future<void> showAreYouSureDialog({
  required BuildContext context,
  required Function() fun,
}) {

  return genericInputDialog(
      context: context,
      title: "Are you sure you want to delete this flashcar?",
      inputs: [],
      function: () async {
      fun();
    },

  );




}

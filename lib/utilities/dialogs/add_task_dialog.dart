//Opens a new pop-up window allowing user to add a task. Function invoked on (+) button press.
import 'package:stoodee/utilities/dialogs/not_for_production_use/generic_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:stoodee/utilities/theme/theme.dart';

import '../../services/todoTasks/todo_service.dart';

Future<void> showAddTaskDialog({
  required BuildContext context,
}) {
  TextEditingController taskController = TextEditingController();
  return genericInputDialog(
    context: context,
    title: 'Add Task',
    inputs: [
      TextField(
        style: TextStyle(color:usertheme.textColor),
        controller: taskController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color:usertheme.textColor.withOpacity(0.3)),
          hintText: 'task text',
        ),
      )
    ],
    function: () async {
      if (taskController.text.isNotEmpty) {
        await TodoService().createTask(text: taskController.text);
      }
    },
  );
}

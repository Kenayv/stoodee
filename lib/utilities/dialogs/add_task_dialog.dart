//Opens a new pop-up window allowing user to add a task. Function invoked on (+) button press.
import 'package:stoodee/services/todo_service/todo_service.dart';
import 'package:stoodee/utilities/dialogs/generic_input_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showAddTaskDialog({
  required BuildContext context,
}) {
  TextEditingController taskController = TextEditingController();
  return genericInputDialog(
    context: context,
    title: 'Add Task',
    inputs: [
      TextField(
        controller: taskController,
        decoration: const InputDecoration(
          hintText: 'task text',
        ),
      )
    ],
    function: () {
      if (taskController.text.isNotEmpty) {
        TodoService().addTask(taskController.text);
      }
    },
  );
}

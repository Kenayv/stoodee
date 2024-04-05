//Opens a new pop-up window allowing user to add a task. Function invoked on (+) button press.
<<<<<<< HEAD
import 'package:stoodee/services/local_crud/todo_service.dart';
=======
>>>>>>> a968878df1f15000cf14772660c6c5d37a4335e3
import 'package:stoodee/utilities/dialogs/generic_input_dialog.dart';
import 'package:flutter/material.dart';

import '../../services/local_crud/todo_service.dart';

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
    function: () async {
      if (taskController.text.isNotEmpty) {
        await TodoService().createTask(text: taskController.text);
      }
    },
  );
}

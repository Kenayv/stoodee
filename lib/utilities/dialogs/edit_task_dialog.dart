import 'package:flutter/material.dart';
import 'package:stoodee/services/crud/todo_service/todo_service.dart';
import 'package:stoodee/utilities/dialogs/generic_input_dialog.dart';

Future<String?> showEditTaskDialog({
  required BuildContext context,
  required int index,
}) async {
  TextEditingController taskController = TextEditingController();
  taskController.text =
      TodoService().taskAt(index); // Set text from TodoService

  return await genericInputDialog(
    context: context,
    title: 'Edit Task', // Changed title to 'Edit Task'
    inputs: [
      TextField(
        controller: taskController,
        decoration: const InputDecoration(
          hintText: 'Task text',
        ),
      )
    ],
    function: () {
      return taskController.text;
    },
  );
}

import 'package:flutter/material.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_task.dart';
import 'package:stoodee/utilities/dialogs/not_for_production_use/generic_input_dialog.dart';

import '../../services/todoTasks/todo_service.dart';

Future<String?> showEditTaskDialog(
    {required BuildContext context, required Task task}) async {
  TextEditingController taskController = TextEditingController();
  taskController.text = task.text; // Set text from TodoService

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
    function: () async {
      await TodoService().updateTask(
        task: task,
        text: taskController.text,
      );
    },
  );
}

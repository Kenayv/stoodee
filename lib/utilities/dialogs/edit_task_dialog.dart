import 'package:flutter/material.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_task.dart';
<<<<<<< HEAD
import 'package:stoodee/services/local_crud/todo_service.dart';
=======
>>>>>>> a968878df1f15000cf14772660c6c5d37a4335e3
import 'package:stoodee/utilities/dialogs/generic_input_dialog.dart';

import '../../services/local_crud/todo_service.dart';

Future<String?> showEditTaskDialog(
    {required BuildContext context, required DatabaseTask task}) async {
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
      await TodoService().updateTask(task: task, text: taskController.text);
    },
  );
}

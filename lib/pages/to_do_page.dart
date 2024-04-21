import 'package:flutter/material.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_task.dart';
import 'package:stoodee/utilities/dialogs/add_task_dialog.dart';
import 'package:gap/gap.dart';
import 'package:stoodee/utilities/page_utilities/todo_widgets.dart';
import 'package:stoodee/services/todoTasks/todo_service.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPage();
}

class _ToDoPage extends State<ToDoPage> {
  Future<void> completeTask(DatabaseTask task) async {
    await TodoService().removeTask(task);
    await TodoService().incrTasksCompletedToday();
    setState(() {});
  }

  Future<void> addTask() async {
    await showAddTaskDialog(context: context);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DatabaseTask>>(
      future: TodoService().getTasks(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            List<DatabaseTask> tasks = snapshot.data ?? [];
            return Scaffold(
              body: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Column(
                    children: [
                      const Gap(20),
                      taskListView(
                        context: context,
                        tasks: tasks,
                        onDismissed: completeTask,
                      ),
                      const Gap(5),
                      buildAddTaskButton(onPressed: addTask),
                    ],
                  ),
                ),
              ),
            );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

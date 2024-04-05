import 'package:flutter/material.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_task.dart';
import 'package:stoodee/services/local_crud/todo_service.dart';
import 'package:stoodee/utilities/dialogs/add_task_dialog.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:gap/gap.dart';
import 'package:stoodee/utilities/reusables/reusable_stoodee_button.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({
    super.key,
  });

  @override
  State<ToDoPage> createState() => _ToDoPage();
}

class _ToDoPage extends State<ToDoPage> {
  Future<void> completeTask(DatabaseTask task) async {
    await TodoService().removeTask(task);
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

  //FIXME: dużo tu sie musi pozmieniac szczegolnie case:
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DatabaseTask>>(
        future: TodoService().loadTasks(),
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
                        StoodeeButton(
                          onPressed: addTask,
                          child: const Icon(Icons.add,
                              color: Colors.white, size: 30),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        });
  }
}

ListView taskListView({
  required BuildContext context,
  required List<DatabaseTask> tasks,
  required Function onDismissed,
}) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: tasks.length,
    itemBuilder: (context, index) {
      return taskItem(
        text: tasks[index].text,
        onDismissed: () async {
          await onDismissed(tasks[index]);
        },
      );
    },
  );
}

ListTile taskItem({
  required String text,
  required Function onDismissed,
}) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 18),
    minVerticalPadding: 10,
    splashColor: Colors.transparent,
    title: ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Dismissible(
        key: UniqueKey(),
        background: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 15.0),
          decoration: const BoxDecoration(
            color: Colors.green,
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 30,
          ),
        ),
        secondaryBackground: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 15.0),
          height: 0.2,
          decoration: const BoxDecoration(
            color: Colors.red,
          ),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 30,
          ),
        ),
        onDismissed: (_) {
          onDismissed();
        },
        child: Container(
          decoration: const BoxDecoration(
            color: analogusColor,
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    ),
    onTap: () {
      print("tapped on task : $text");
    },
    onLongPress: () {
      print("longpressed on task : $text");
    },
  );
}

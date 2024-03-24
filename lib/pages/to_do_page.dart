import 'package:flutter/material.dart';
import 'package:stoodee/services/todo_service/todo_service.dart';
import 'package:stoodee/utilities/dialogs/add_task_dialog.dart';
import 'package:stoodee/utilities/dialogs/edit_task_dialog.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({
    super.key,
  });

  @override
  State<ToDoPage> createState() => _ToDoPage();
}

class _ToDoPage extends State<ToDoPage> {
  late List<String> _tasks;

  void completeTask(int index) {
    TodoService().removeTaskAt(index);
    setState(() {});
  }

  void addTask() async {
    await showAddTaskDialog(context: context);
    setState(() {});
  }

  void editTask(int index, String newText) {
    TodoService().editTaskAt(index, newText);
    setState(() {
      _tasks = TodoService().tasks;
    });
  }

  @override
  void initState() {
    super.initState();
    _tasks = TodoService().tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'To Do:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            taskListView(
              context: context,
              tasks: _tasks,
              onDismissed: completeTask,
              onLongPressed: editTask, // Pass the editTask callback
            ),
            FloatingActionButton(
              onPressed: addTask,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

ListView taskListView({
  required BuildContext context,
  required List<String> tasks,
  required Function onDismissed,
  required Function onLongPressed,
}) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: tasks.length,
    itemBuilder: (context, index) {
      return taskItem(
        text: tasks[index],
        onLongPress: () async {
          //FIXME: spaghetti code. This returns string, AddTask() adds task.
          final String? newText = await showEditTaskDialog(
            context: context,
            index: index,
          );
          if (newText != null && newText.isNotEmpty) {
            onLongPressed(index, newText);
          }
        },
        onDismissed: () {
          onDismissed(index);
        },
      );
    },
  );
}

ListTile taskItem({
  required String text,
  required Function onDismissed,
  required Function onLongPress,
}) {
  return ListTile(
    title: Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 30,
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20.0),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      onDismissed: (_) {
        onDismissed();
      },
      child: ListTile(
        title: Text(text),
      ),
    ),
    onLongPress: () async {
      await onLongPress();
    },
  );
}

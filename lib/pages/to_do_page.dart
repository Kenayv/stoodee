import 'package:flutter/material.dart';
import 'package:stoodee/services/crud/todo_service/todo_service.dart';
import 'package:stoodee/utilities/dialogs/add_task_dialog.dart';

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
}) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: tasks.length,
    itemBuilder: (context, index) {
      return taskItem(
        text: tasks[index],
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
  );
}

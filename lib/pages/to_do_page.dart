import 'package:flutter/material.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({
    super.key,
  });

  @override
  State<ToDoPage> createState() => _ToDoPage();
}

class _ToDoPage extends State<ToDoPage> {
  //FIXME: DEBUG STATIC ARRAY
  List<String> tasks = [
    "Incomplete Task 1",
    "debug Task 2",
    "Incomplete Task 3",
    "debug Task 4",
    "Incomplete Task 5",
  ];

  void completeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
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
              tasks: tasks,
              onDismissed: completeTask,
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

ListTile taskItem({required String text, required Function onDismissed}) {
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

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_task.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:stoodee/utilities/reusables/reusable_stoodee_button.dart';

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
    title: Container(
      decoration: BoxDecoration(boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(80, 80, 80, 1.0),
          blurRadius: 1,
          offset: Offset(1, 2),
        )
      ], borderRadius: BorderRadius.circular(15.0)),
      child: ClipRRect(
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
    ),
    onTap: () {
      log("tapped on task : $text");
    },
    onLongPress: () {
      log("longpressed on task : $text");
    },
  );
}

StoodeeButton buildAddTaskButton({required void Function() onPressed}) {
  return StoodeeButton(
    onPressed: onPressed,
    child: const Icon(
      Icons.add,
      color: Colors.white,
      size: 30,
    ),
  );
}
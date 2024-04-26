import 'package:flutter/material.dart';
import 'package:stoodee/utilities/globals.dart';

import 'flashcard_widget.dart';

ListView taskListViewIntro({
  required BuildContext context,
}) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: 3,
    itemBuilder: (context, index) {
      return taskItem(
        text: "task${index + 1}",
      );
    },
  );
}

ListTile taskItem({
  required String text,
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
    onTap: () {},
    onLongPress: () {},
  );
}

List<Widget> flashcardSetListViewIntro({
  required BuildContext context,
}) {
  List<Widget> flashcardList = [];

  for (int i = 0; i < 4; i++) {
    flashcardList.add(
      FlashCardSetWidgetIntro(
        //FIXME: onLongPressed function could be passed right there as an argument.to allow setting state.
        context: context,
        name: "set$i",
        fcSetlength: 3 - i,
      ),
    );
  }

  flashcardList.add(const Padding(padding: EdgeInsets.only(bottom: 20)));

  return flashcardList;
}

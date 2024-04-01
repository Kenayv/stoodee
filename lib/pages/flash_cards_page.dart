import 'package:flutter/material.dart';

import 'package:stoodee/services/crud/flashcards_service/flashcard_service.dart';
import 'package:stoodee/services/crud/flashcards_service/flashcard_set.dart';
import 'package:stoodee/utilities/dialogs/add_flashcard_set_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:stoodee/utilities/containers.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:gap/gap.dart';


class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({
    super.key,
  });

  @override
  State<FlashcardsPage> createState() => _FlashcardsPage();
}


void tap(BuildContext context,SetContainer container){


  context.go('/flash_cards_reader', extra: container);
}

void deletingfunction(){
  //FIXME: ONLY DEBUGGING OPTION, LINK IT TO A REAL FUNCTION LATER
  print("deleted");
}


ListTile _flashcardSetItem({
  required BuildContext context,
  required FlashcardSet fcSet,
  required String name,
}) {
  return ListTile(
    title: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: analogusColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.topCenter,
                height: 35,
                child: const Row(
                  children: [
                    //TODO: MAKE THEM DO SOMETHING WITH BUTTONS, AND SPACE THEM CORRECTLY
                    Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.white,
                    ),
                    Icon(Icons.star, size: 20, color: Colors.white),
                    Icon(Icons.lock, size: 20, color: Colors.white),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                height: 40,
                child: Text(
                  name,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                height: 100,
                child: Text(
                  'Pair count: ${fcSet.pairCount}',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    onTap: () => tap(context,SetContainer(set: fcSet, name: name)),
    onLongPress: deletingfunction,
  );
}

List<Widget> flashcardSetListView({required BuildContext context}) {
  final List<FlashcardSet> flashcardSets = FlashcardService().fcSets;

  List<Widget> flashcardList = [];

  for (int i = 0; i < flashcardSets.length; i++) {
    flashcardList.add(_flashcardSetItem(
      context: context,
      fcSet: flashcardSets[i],
      name: flashcardSets[i].name,
    ));
  }

  return flashcardList;
}

class _FlashcardsPage extends State<FlashcardsPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Gap(10),
            GridView.count(
              shrinkWrap: true,
              primary: false,
              childAspectRatio: (1 / 1.3),
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              crossAxisCount: 2,
              children: flashcardSetListView(context: context),
            ),
            Gap(15),
        FloatingActionButton(
          onPressed: () async {
            await showAddFcSetDialog(context: context);
            setState(() {});

          },
          child: const Icon(Icons.add),
        )
          ],
        ),

        //flashcardSetListView(context: context),
      ),

    );
  }
}

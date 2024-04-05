import 'package:flutter/material.dart';
import 'package:stoodee/services/local_crud/flashcard_service.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/utilities/dialogs/add_flashcard_set_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:stoodee/utilities/containers.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:gap/gap.dart';
import 'package:stoodee/utilities/reusables/custom_grid_view.dart';

import '../utilities/reusables/reusable_stoodee_button.dart';

const double iconSize = 40;

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({
    super.key,
  });

  @override
  State<FlashcardsPage> createState() => _FlashcardsPage();
}

void tap(BuildContext context, SetContainer container) {
  context.go('/flash_cards_reader', extra: container);
}

void deletingfunction() {
  //FIXME: ONLY DEBUGGING OPTION, LINK IT TO A REAL FUNCTION LATER
  print("deleted");
}

ListTile _flashcardSetItem({
  required BuildContext context,
  required DatabaseFlashcardSet fcSet,
  required String name,
}) {
  return ListTile(
    title: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: const BoxDecoration(
          color: analogusColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Gap(10),
              Container(
                alignment: Alignment.topCenter,
                height: 35,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //TODO: MAKE THEM DO SOMETHING WITH BUTTONS, AND SPACE THEM CORRECTLY
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 8,
                      child: TextButton(
                          onPressed: () {
                            print("add");
                          },
                          child: const Icon(
                            Icons.add,
                            size: 20,
                            color: Colors.white,
                          )),
                    ),

                    SizedBox(
                        width: MediaQuery.of(context).size.width / 8,
                        child: TextButton(
                            onPressed: () {
                              print("favorite");
                            },
                            child: const Icon(Icons.star,
                                size: 20, color: Colors.white))),

                    SizedBox(
                        width: MediaQuery.of(context).size.width / 8,
                        child: TextButton(
                            onPressed: () {
                              print("lock");
                            },
                            child: const Icon(Icons.lock,
                                size: 20, color: Colors.white))),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  name,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: 100,
                  child: Text(
                    'Pair count: ${fcSet.pairCount}',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    onTap: () => tap(context, SetContainer(currentSet: fcSet, name: name)),
    onLongPress: deletingfunction,
  );
}

List<Widget> flashcardSetListView({
  required BuildContext context,
  required List<DatabaseFlashcardSet> fcSets,
}) {
  List<Widget> flashcardList = [];

  for (int i = 0; i < fcSets.length; i++) {
    flashcardList.add(_flashcardSetItem(
      context: context,
      fcSet: fcSets[i],
      name: fcSets[i].name,
    ));
  }

  return flashcardList;
}

class _FlashcardsPage extends State<FlashcardsPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> addFcSet() async {
    await showAddFcSetDialog(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DatabaseFlashcardSet>>(
      future: FlashcardService().loadFcSets(),
      builder: (context, snapshot) {
        List<DatabaseFlashcardSet> flashcardSets = snapshot.data ?? [];
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    CustomGridLayout(
                      crossAxisCount: 2,
                      items: flashcardSetListView(
                        context: context,
                        fcSets: flashcardSets,
                      ),
                    ),
                    const SizedBox(height: 15),
                    StoodeeButton(
                      onPressed: addFcSet,
                      child:
                          const Icon(Icons.add, color: Colors.white, size: 30),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            );
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../services/local_crud/local_database_service/database_flashcard_set.dart';
import '../containers.dart';
import '../dialogs/add_flashcard_dialog.dart';
import '../globals.dart';

void tap(BuildContext context, SetContainer container) {
  context.go('/flash_cards_reader', extra: container);
}

void deletingfunction() {
  //FIXME: ONLY DEBUGGING OPTION, LINK IT TO A REAL FUNCTION LATER
  print("deleted");
}

class FlashCardSetWidget extends StatefulWidget {
  const FlashCardSetWidget({
    super.key,
    required this.context,
    required this.fcSet,
    required this.name,
  });

  @override
  State<FlashCardSetWidget> createState() => _FlashCardSetWidgetState();

  final BuildContext context;
  final DatabaseFlashcardSet fcSet;
  final String name;
}

class _FlashCardSetWidgetState extends State<FlashCardSetWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: const BoxDecoration(
            color: analogusColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: primaryAppColor,
                spreadRadius: 1,
                offset: Offset(3.0, 1),
              )
            ],
          ),
          child: Center(
            child: Column(
              children: [
                const Gap(10),
                Container(
                  alignment: Alignment.topCenter,
                  height: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 8,
                        child: TextButton(
                            onPressed: () async {
                              await showAddFlashcardDialog(
                                context: context,
                                fcSet: widget.fcSet,
                              );
                              setState(() {});
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
                    widget.name,
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
                      'Pair count: ${widget.fcSet.pairCount}',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () => tap(
          context, SetContainer(currentSet: widget.fcSet, name: widget.name)),
      splashColor: Colors.transparent,
      onLongPress: deletingfunction,
    );
  }
}

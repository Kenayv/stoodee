import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stoodee/services/flashcards/flashcard_service.dart';
import 'package:stoodee/services/router/route_functions.dart';
import 'package:stoodee/utilities/containers.dart';
import 'package:stoodee/utilities/dialogs/add_flashcard_dialog.dart';
import 'package:stoodee/utilities/dialogs/delete_fcset_dialog.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/utilities/theme/theme.dart';

Future<void> showRegularOrFcRushDialog(
  BuildContext context,
  SetContainer container,
) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Select flashcards mode"),
        content: const Text("Selech preffered game mode:"),
        actions: <Widget>[
          TextButton(
            child: const Text('normal mode'),
            onPressed: () {
              goRouterToFlashCardReader(context, container);
            },
          ),
          TextButton(
            child: const Text('flashcards Rush'),
            onPressed: () {
              goRouterToFlashCardRush(context, container);
            },
          ),
        ],
      );
    },
  );
}

void tap(
  BuildContext context,
  SetContainer container,
) async {
  await showRegularOrFcRushDialog(context, container);
}

class FlashCardSetWidget extends StatefulWidget {
  const FlashCardSetWidget({
    super.key,
    required this.context,
    required this.fcSet,
    required this.name,
    required this.onLongPressed,
  });

  @override
  State<FlashCardSetWidget> createState() => _FlashCardSetWidgetState();

  final BuildContext context;
  final DatabaseFlashcardSet fcSet;
  final String name;
  final Future<void> Function() onLongPressed;
}

class _FlashCardSetWidgetState extends State<FlashCardSetWidget> {
  Future<void> deleteSet() async {
    if (await showDeleteFcSetDialog(context: context, fcSet: widget.fcSet)) {
      await FlashcardsService().removeFcSet(widget.fcSet);
    }
    setState(() {});
  }

  List<BoxShadow> resolveWidgetShadows() {
    List<BoxShadow> l = [];

    if (widget.fcSet.pairCount > 2) {
      l.add(const BoxShadow(
        color: Color.fromRGBO(75, 0, 178, 1.0),
        spreadRadius: 1,
        offset: Offset(9.0, 3.0),
      ));
    }

    if (widget.fcSet.pairCount > 1) {
      l.add(const BoxShadow(
        color: Color.fromRGBO(92, 0, 206, 1.0),
        spreadRadius: 1,
        offset: Offset(5.0, 2),
      ));
    }

    if (widget.fcSet.pairCount > 0) {
      l.add(const BoxShadow(
        color: primaryAppColor,
        spreadRadius: 1,
        offset: Offset(2.0, 1),
      ));
    }

    return l;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            decoration: BoxDecoration(
              color: usertheme.analogousColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: resolveWidgetShadows(),
            ),
            child: Center(
              child: Column(
                children: [
                  const Gap(10),
                  Container(
                    alignment: Alignment.topCenter,
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
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
                        'Total pairs: ${widget.fcSet.pairCount}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
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
        onLongPress: () => widget.onLongPressed() //deleteSet,
        );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stoodee/utilities/page_utilities/flashcards/fc_set_widget.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/utilities/dialogs/add_flashcard_set_dialog.dart';
import 'package:stoodee/utilities/reusables/custom_grid_view.dart';
import 'package:stoodee/services/flashcards/flashcard_service.dart';
import 'package:stoodee/utilities/dialogs/delete_fcset_dialog.dart';
import 'package:stoodee/utilities/reusables/reusable_stoodee_button.dart';
import 'package:stoodee/utilities/theme/theme.dart';

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({super.key});

  @override
  State<FlashcardsPage> createState() => _FlashcardsPage();
}

class _FlashcardsPage extends State<FlashcardsPage> {
  Future<void> deleteSetDialog(
    BuildContext context,
    DatabaseFlashcardSet fcSet,
  ) async {
    log("longpressed");
    if (await showDeleteFcSetDialog(context: context, fcSet: fcSet)) {
      await FlashcardsService().removeFcSet(fcSet);
      setState(() {});
    }
  }

  List<Widget> buildFlashcardSetListView({
    required BuildContext context,
    required List<DatabaseFlashcardSet> fcSets,
  }) {
    List<Widget> flashcardList = [];

    for (int i = 0; i < fcSets.length; i++) {
      var flashCardSetWidget = FlashCardSetWidget(
        context: context,
        fcSet: fcSets[i],
        name: fcSets[i].name,
        onLongPressed: () async => deleteSetDialog(
          context,
          fcSets[i],
        ),
      );
      flashcardList.add(
        flashCardSetWidget,
      );
    }

    return flashcardList;
  }

  StoodeeButton addFcSetButton() {
    return StoodeeButton(
      onPressed: () async {
        await showAddFcSetDialog(context: context);
        setState(() {});
      },
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DatabaseFlashcardSet>>(
      future: FlashcardsService().getFlashcardSets(),
      builder: (context, snapshot) {
        List<DatabaseFlashcardSet> flashcardSets = snapshot.data ?? [];
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return Scaffold(
              backgroundColor: usertheme.backgroundColor,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.startFloat,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    CustomGridLayout(
                      crossAxisCount: 2,
                      items: buildFlashcardSetListView(
                        context: context,
                        fcSets: flashcardSets,
                      ),
                    ),
                    const SizedBox(height: 15),
                    addFcSetButton(),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

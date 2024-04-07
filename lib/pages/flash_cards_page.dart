import 'package:flutter/material.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/utilities/dialogs/add_flashcard_dialog.dart';
import 'package:stoodee/utilities/dialogs/add_flashcard_set_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:stoodee/utilities/containers.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:gap/gap.dart';
import 'package:stoodee/utilities/reusables/custom_grid_view.dart';

import '../services/flashcard_service.dart';
import '../utilities/reusables/reusable_stoodee_button.dart';
import '../utilities/reusables/custom_flash_card_set_widget.dart';

const double iconSize = 40;

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({
    super.key,
  });

  @override
  State<FlashcardsPage> createState() => _FlashcardsPage();
}




List<Widget> flashcardSetListView({
  required BuildContext context,
  required List<DatabaseFlashcardSet> fcSets,
}) {
  List<Widget> flashcardList = [];

  for (int i = 0; i < fcSets.length; i++) {
    flashcardList.add(FlashCardSetWidget(
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
      future: FlashcardsService().getFlashcardSets(),
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

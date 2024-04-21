import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/services/router/route_functions.dart';
import 'package:stoodee/utilities/reusables/reusable_card.dart';
import 'package:stoodee/utilities/reusables/reusable_stoodee_button.dart';
import 'package:stoodee/utilities/snackbar/create_snackbar.dart';

import 'package:stoodee/utilities/dialogs/add_flashcard_dialog.dart';
import 'package:stoodee/utilities/globals.dart';
import 'custom_appbar.dart';

class EmptyReaderScaffold extends StatefulWidget {
  const EmptyReaderScaffold({super.key, required this.fcset});

  final DatabaseFlashcardSet fcset;

  @override
  State<EmptyReaderScaffold> createState() => _EmptyReaderScaffoldState();
}

class _EmptyReaderScaffoldState extends State<EmptyReaderScaffold> {
  void nothing() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: const Text(""),
        titleWidget: Text(
          widget.fcset.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: StoodeeButton(
                      onPressed: () {
                        goRouterToMain(context);
                      },
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: const Text("empty"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: LinearPercentIndicator(
                      backgroundColor: primaryAppColor.withOpacity(0.08),
                      percent: 0,
                      linearGradient: const LinearGradient(
                        colors: [primaryAppColor, secondaryAppColor],
                      ),
                      animation: true,
                      lineHeight: 20,
                      restartAnimation: false,
                      animationDuration: 150,
                      curve: Curves.easeOut,
                      barRadius: const Radius.circular(10),
                      animateFromLastPercent: true,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: FlipCard(
                    speed: 250,
                    onFlip: () {},
                    side: CardSide.FRONT,
                    direction: FlipDirection.HORIZONTAL,
                    front: const ReusableCard(
                      text: "add flashcard below",
                    ),
                    back: const ReusableCard(
                      text: "pls",
                    ),
                  ),
                ),
                StoodeeButton(
                    onPressed: () async {
                      await showAddFlashcardDialog(
                        context: context,
                        fcSet: widget.fcset,
                      );

                      if (widget.fcset.pairCount > 0) {
                        /*
                        WidgetsBinding.instance.addPostFrameCallback((_) =>   ScaffoldMessenger.of(context).showSnackBar(
                            createSuccessSnackbar(
                                "Flashcard added :3")));

                        */
                        ScaffoldMessenger.of(context).showSnackBar(
                            createSuccessSnackbar("flashcard added :3"));
                        goRouterToMain(context);
                      } else {
                        /*
                        WidgetsBinding.instance.addPostFrameCallback((_) =>   ScaffoldMessenger.of(context).showSnackBar(
                            createErrorSnackbar(
                                "Flashcard still not added :3")));

                         */
                        ScaffoldMessenger.of(context).showSnackBar(
                            createErrorSnackbar(
                                "Flashcard still not added :3"));
                      }
                    },
                    child: Text(
                      "Add flashcard",
                      style: buttonTextStyle,
                    )),
                const Expanded(child: Text("")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

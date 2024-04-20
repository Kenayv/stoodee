import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:lottie/lottie.dart';
import 'package:stoodee/services/flashcard_service/fc_difficulty.dart';
import 'package:stoodee/services/flashcard_service/flashcard_service.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/services/router/route_functions.dart';

import 'package:stoodee/utilities/reusables/custom_appbar.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:stoodee/utilities/reusables/reusable_card.dart';
import 'package:stoodee/utilities/reusables/reusable_stoodee_button.dart';

import 'package:stoodee/services/local_crud/crud_exceptions.dart';
import 'package:stoodee/utilities/reusables/empty_flashcard_reader_scaffold.dart';
import 'package:stoodee/utilities/snackbar/create_snackbar.dart';

class FlashCardsReader extends StatefulWidget {
  const FlashCardsReader({super.key, required this.fcSet});

  final DatabaseFlashcardSet fcSet;

  @override
  State<FlashCardsReader> createState() => _FlashCardsReader();
}

class _FlashCardsReader extends State<FlashCardsReader>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late Future<List<DatabaseFlashcard>> _loadFlashcardsFuture;
  late final DatabaseFlashcardSet currentFcSet;

  @override
  void initState() {
    super.initState();
    imageCache.clear();

    currentFcSet = widget.fcSet;

    _controller =
        AnimationController(vsync: this, duration: Durations.extralong4);
    _loadFlashcardsFuture =
        FlashcardsService().loadActiveFlashcardsFromSet(fcSet: widget.fcSet);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double isNotZero(int completed, int toBeCompleted) {
    if (toBeCompleted == 0) {
      return 0;
    } else if (completed / toBeCompleted > 1) {
      return 1;
    } else if (completed / toBeCompleted < 0) {
      return 0;
    } else {
      return completed / toBeCompleted;
    }
  }

  void sendToFlashCards() {
    goRouterToMain(context, "l");
  }

  int completed = 0;
  int cardIndex = 0;
  bool shownav = false;

  void onSetDone() {
    log("SET DONE!!!");
    if (completed == widget.fcSet.pairCount) {
      FlashcardsService().incrFcsCompletedToday();
      var ticker = _controller.forward();
      ticker.whenComplete(() => _controller.reset());
    }
  }

  void addProgress() {
    completed++;
    setState(() {
      //onSetDone();
    });
  }

  void setNavFalse() {
    setState(() {
      shownav = false;
    });
  }

  String getDisplayDateText({required DateTime displayDate}) {
    DateTime now = DateTime.now();
    Duration difference = displayDate.difference(now);

    if (difference.inDays > 1) {
      return "show in:\n ${difference.inDays} ${difference.inDays > 1 ? "Days" : "Day"}";
    } else if (difference.inHours > 1) {
      return "show in:\n ${difference.inHours}h ${difference.inHours > 1 ? "Hours" : "Hour"}";
    } else if (difference.inMinutes > 1) {
      return "show in:\n ${difference.inMinutes}  ${difference.inMinutes > 1 ? "Minutes" : "Minute"}";
    } else {
      return "Show now";
    }
  }

  Container difficultyRow({
    required Function removeCurrentFcFromSet,
    required DatabaseFlashcard flashcard,
  }) {
    if (shownav == true) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 120),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                StoodeeButton(
                  child: Text("Latwe", style: biggerButtonTextStyle),
                  onPressed: () async {
                    addProgress();
                    setNavFalse();
                    removeCurrentFcFromSet();

                    await FlashcardsService().calcFcDisplayDate(
                      fc: flashcard,
                      newDifficulty: flashcard.cardDifficulty - 1,
                    );
                  },
                ),
                Text(
                  getDisplayDateText(
                    displayDate: calculateDateToShowFc(
                        cardDifficulty: flashcard.cardDifficulty - 1),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                StoodeeButton(
                  child: Text("Srednie", style: biggerButtonTextStyle),
                  onPressed: () async {
                    addProgress();
                    setNavFalse();
                    removeCurrentFcFromSet();

                    await FlashcardsService().calcFcDisplayDate(
                      fc: flashcard,
                      newDifficulty: flashcard.cardDifficulty,
                    );
                  },
                ),
                Text(
                  getDisplayDateText(
                    displayDate: calculateDateToShowFc(
                        cardDifficulty: flashcard.cardDifficulty),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                StoodeeButton(
                  child: Text("Trudne", style: biggerButtonTextStyle),
                  onPressed: () async {
                    addProgress();
                    setNavFalse();
                    removeCurrentFcFromSet();

                    await FlashcardsService().calcFcDisplayDate(
                      fc: flashcard,
                      newDifficulty: flashcard.cardDifficulty + 2,
                    );
                  },
                ),
                Text(
                  getDisplayDateText(
                    displayDate: calculateDateToShowFc(
                        cardDifficulty: flashcard.cardDifficulty + 2),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: () async {
        goRouterToMain(context);
        return true;
      },
      child: FutureBuilder<List<DatabaseFlashcard>>(
        future: _loadFlashcardsFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              try {
                final List<DatabaseFlashcard> flashcards = snapshot.data ?? [];
                final int totalFlashcardsCount = flashcards.length + completed;

                if (completed == totalFlashcardsCount &&
                    currentFcSet.pairCount != 0) {
                  log("SET DONE!!!");
                  FlashcardsService().incrFcsCompletedToday();
                  var ticker = _controller.forward();
                  ticker.whenComplete(() => _controller.reset());
                  //doesnt work because it redirects to empty reader page instantly, and for some reason this "if" is called 2 times??

/*
                    WidgetsBinding.instance.addPostFrameCallback(
                          (_) =>context.go("/flash_cards_reader/dialog",extra: SetContainer(currentSet: widget.fcSet, name: widget.fcSet.name))
                    );
                     //will make tihs work when paircount is all done

 */
                }

                final DatabaseFlashcard currentFlashcard =
                    FlashcardsService().getRandFcFromList(fcList: flashcards);

                final DatabaseFlashcardSet currentSet = widget.fcSet;
                double indicatorValue =
                    isNotZero(completed, currentSet.pairCount);

                return Scaffold(
                  appBar: CustomAppBar(
                    leading: const Text(''),
                    titleWidget: Text(
                      currentSet.name,
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
                                  onPressed: sendToFlashCards,
                                  child: const Icon(Icons.arrow_back,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: Text("$completed/$totalFlashcardsCount"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                child: LinearPercentIndicator(
                                  backgroundColor:
                                      primaryAppColor.withOpacity(0.08),
                                  percent: indicatorValue,
                                  linearGradient: const LinearGradient(
                                    colors: [
                                      primaryAppColor,
                                      secondaryAppColor
                                    ],
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
                                onFlip: () {
                                  setState(() {
                                    shownav = true;
                                  });
                                },
                                side: CardSide.FRONT,
                                direction: FlipDirection.HORIZONTAL,
                                front: ReusableCard(
                                  text: currentFlashcard.frontText,
                                ),
                                back: ReusableCard(
                                  text: currentFlashcard.backText,
                                ),
                              ),
                            ),
                            const Expanded(child: Text("")),
                            difficultyRow(
                              flashcard: currentFlashcard,
                              removeCurrentFcFromSet: () =>
                                  flashcards.remove(currentFlashcard),
                            ),
                          ],
                        ),
                      ),
                      IgnorePointer(
                        child: Lottie.asset(
                          alignment: Alignment.center,
                          'lib/assets/sparkle.json',
                          controller: _controller,
                          height: MediaQuery.of(context).size.height * 0.45,
                          width: MediaQuery.of(context).size.width * 0.45,
                          fit: BoxFit.cover,
                          repeat: false,
                        ),
                      ),
                    ],
                  ),
                );
              } on FlashcardListEmpty {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => ScaffoldMessenger.of(context).showSnackBar(
                    createErrorSnackbar(
                        "Current set is empty. Add some flashcards before studying!"),
                  ),
                );
                return EmptyReaderScaffold(fcset: widget.fcSet);
              }

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

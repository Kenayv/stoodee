import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flip_card/flip_card.dart';
import 'package:lottie/lottie.dart';
import 'package:stoodee/services/flashcard_service.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';

import 'package:stoodee/utilities/reusables/custom_appbar.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:stoodee/utilities/reusables/reusable_card.dart';
import 'package:stoodee/utilities/reusables/reusable_stoodee_button.dart';

class FlashCardsReader extends StatefulWidget {
  const FlashCardsReader({super.key, required this.fcSet});

  final DatabaseFlashcardSet fcSet;

  @override
  State<FlashCardsReader> createState() => _FlashCardsReader();
}

class _FlashCardsReader extends State<FlashCardsReader>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    imageCache.clear();
    _controller =
        AnimationController(vsync: this, duration: Durations.extralong4);
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
    context.go("/Main", extra: "l");
  }

  int completed = 0;
  int cardIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DatabaseFlashcard>>(
      future: FlashcardsService().loadFlashcardsFromSet(fcSet: widget.fcSet),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final List<DatabaseFlashcard> flashcards = snapshot.data!;

            final DatabaseFlashcard currentFlashCard =
                FlashcardsService().getRandFcFromList(fcList: flashcards);

            final DatabaseFlashcardSet currentSet = widget.fcSet;
            double indicatorValue = isNotZero(completed, currentSet.pairCount);

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
                          child: Text("$completed/${currentSet.pairCount}"),
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
                            side: CardSide.FRONT,
                            direction: FlipDirection.VERTICAL,
                            front: ReusableCard(
                              text: currentFlashCard.frontText,
                            ),
                            back: ReusableCard(
                              text: currentFlashCard.backText,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            StoodeeButton(
                              size: const Size(80, 30),
                              onPressed: () {
                                completed++;
                                setState(() {
                                  if (completed == currentSet.pairCount) {
                                    var ticker = _controller.forward();
                                    ticker.whenComplete(
                                        () => _controller.reset());
                                  }
                                });
                              },
                              child: Text("add", style: buttonTextStyle),
                            ),
                            StoodeeButton(
                              size: const Size(80, 30),
                              onPressed: () {
                                completed--;
                                setState(() {});
                              },
                              child: Text("unadd", style: buttonTextStyle),
                            ),
                          ],
                        ),
                        const Expanded(child: Text("")),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
                            color: primaryAppColor.withOpacity(0.2),
                          ),
                          padding: const EdgeInsets.only(bottom: 20, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              StoodeeButton(
                                child: Text("Latwe", style: buttonTextStyle),
                                onPressed: () {},
                              ),
                              StoodeeButton(
                                child: Text("Srednie", style: buttonTextStyle),
                                onPressed: () {},
                              ),
                              StoodeeButton(
                                child: Text("Trudne", style: buttonTextStyle),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IgnorePointer(
                    child: Lottie.asset(
                      'lib/assets/sparkle.json',
                      controller: _controller,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                      repeat: false,
                    ),
                  ),
                ],
              ),
            );
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

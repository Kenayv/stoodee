import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:lottie/lottie.dart';
import 'package:stoodee/services/flashcard_service.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/services/router/route_functions.dart';

import 'package:stoodee/utilities/reusables/custom_appbar.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:stoodee/utilities/reusables/reusable_card.dart';
import 'package:stoodee/utilities/reusables/reusable_stoodee_button.dart';

import '../services/local_crud/crud_exceptions.dart';
import '../utilities/reusables/empty_flashcard_reader_scaffold.dart';
import '../utilities/snackbar/create_snackbar.dart';

class FlashCardsReader extends StatefulWidget {
  const FlashCardsReader({super.key, required this.fcSet});

  final DatabaseFlashcardSet fcSet;

  @override
  State<FlashCardsReader> createState() => _FlashCardsReader();
}

class _FlashCardsReader extends State<FlashCardsReader>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late Future<List<DatabaseFlashcard>> _initializeWidgetFuture;


  @override
  void initState() {
    super.initState();
    imageCache.clear();
    _controller =
        AnimationController(vsync: this, duration: Durations.extralong4);
    _initializeWidgetFuture=FlashcardsService().loadFlashcardsFromSet(fcSet: widget.fcSet);

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
  bool shownav=false;




  void onSetDone(){
    log("SET DONE!!!");
    if (completed == widget.fcSet.pairCount) {
      FlashcardsService().incrFcsCompletedToday();
      var ticker = _controller.forward();
      ticker.whenComplete(
              () => _controller.reset());
    }
  }



  void addProgress(){
      completed++;
      setState(() {
        onSetDone();
      });

  }

  void setNavFalse(){

    setState(() {
      shownav=false;
    });

  }



  Container difficultyRow(){

    if(shownav==true){
      return Container(
        decoration: const BoxDecoration(
          borderRadius:
          BorderRadius.all(Radius.circular(4)),
        ),
        padding: const EdgeInsets.only(left:16,right:16,bottom:120),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                StoodeeButton(
                  child: Text("Latwe", style: biggerButtonTextStyle),
                  onPressed: () {
                    addProgress();
                    setNavFalse();


                    //easy function
                  },
                ),
                const Text("1")
              ],
            ),
            Column(
              children: [
                StoodeeButton(
                  child: Text("Srednie", style: biggerButtonTextStyle),
                  onPressed: () {
                    addProgress();
                    setNavFalse();


                    //medium function
                  },
                ),
                const Text("2"),
              ],
            ),
            Column(
              children: [
                StoodeeButton(
                  child: Text("Trudne", style: biggerButtonTextStyle),
                  onPressed: () {
                    addProgress();
                    setNavFalse();


                    //hard function
                  },
                ),
                const Text("3"),
              ],
            ),

          ],
        ),
      );
    }
    else {
      return Container();
    }
  }




  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: () async{
        goRouterToMain(context);
        return true;
      },
      child:FutureBuilder<List<DatabaseFlashcard>>(
        future: _initializeWidgetFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              try {
                final List<DatabaseFlashcard> flashcards = snapshot.data ?? [];

                final DatabaseFlashcard currentFlashCard =
                FlashcardsService().getRandFcFromList(fcList: flashcards);

                final DatabaseFlashcardSet currentSet = widget.fcSet;
                double indicatorValue = isNotZero(
                    completed, currentSet.pairCount);

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
                                  text: currentFlashCard.frontText,
                                ),
                                back: ReusableCard(
                                  text: currentFlashCard.backText,
                                ),
                              ),
                            ),

                            const Expanded(child: Text("")),
                            difficultyRow(),

                          ],
                        ),
                      ),
                      IgnorePointer(
                        child: Lottie.asset(
                          alignment: Alignment.center,
                          'lib/assets/sparkle.json',
                          controller: _controller,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.45,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.45,
                          fit: BoxFit.cover,
                          repeat: false,
                        ),
                      ),
                    ],
                  ),
                );
              } on FlashcardListEmpty{

                WidgetsBinding.instance.addPostFrameCallback((_) =>   ScaffoldMessenger.of(context).showSnackBar(
                    createSnackbar(
                        "Empty Set,add some flashcards first")));


                return EmptyReaderScaffold(fcset:widget.fcSet);

              }


            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

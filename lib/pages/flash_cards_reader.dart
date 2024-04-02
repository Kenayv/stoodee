import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flip_card/flip_card.dart';
import 'package:stoodee/services/crud/flashcards_service/flashcard_set.dart';

import 'package:stoodee/utilities/reusables/custom_appbar.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:stoodee/utilities/reusables/reusable_card.dart';

class FlashCardsReader extends StatefulWidget {
  const FlashCardsReader({super.key, required this.fcSet, required this.name});

  final FlashcardSet fcSet;
  final String name;

  @override
  State<FlashCardsReader> createState() => _FlashCardsReader();
}

class _FlashCardsReader extends State<FlashCardsReader> {
  double isNotZero(int completed, int tobemade) {
    if (tobemade == 0) {
      return 0;
    } else if (completed / tobemade > 1) {
      return 1;
    } else if (completed / tobemade < 0) {
      return 0;
    } else {
      return completed / tobemade;
    }
  }

  void sendToFlashCards() {
    context.go("/Main", extra: "l");
  }

  int completed = 0;
  int cardIndex = 0;
  @override
  Widget build(BuildContext context) {
    FlashcardSet set = widget.fcSet;
    String name = widget.name;
    int tobemade = 3; //set.pairCount;
    double indicatorvalue = isNotZero(completed, tobemade);

    return Scaffold(
      appBar: CustomAppBar(
          leading: const Text(''),
          titleWidget: Text(name,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold))),
      body: Center(
          child: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(top: 15),
              child: Text("$completed/$tobemade")),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: LinearPercentIndicator(
                backgroundColor: primaryAppColor.withOpacity(0.08),
                percent: indicatorvalue,
                linearGradient: const LinearGradient(
                    colors: [primaryAppColor, secondaryAppColor]),
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
                front: ReusableCard(text: "lollo"),
                back: ReusableCard(text: "ollol")),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    completed++;
                    setState(() {});
                  },
                  child: const Text("add")),
              ElevatedButton(
                  onPressed: () {
                    completed--;
                    setState(() {});
                  },
                  child: const Text("unadd")),
            ],
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: ElevatedButton(
              onPressed: sendToFlashCards,
              child: const Icon(Icons.arrow_back),
            ),
          )
        ],
      )),
    );
  }
}

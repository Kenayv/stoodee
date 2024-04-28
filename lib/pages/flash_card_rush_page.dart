import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:stoodee/services/flashcards/flashcard_service.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_user.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/services/router/route_functions.dart';
import 'package:stoodee/utilities/page_utilities/flashcards/fc_reader_widget.dart';
import 'package:stoodee/utilities/reusables/custom_appbar.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:stoodee/utilities/page_utilities/reusable_card.dart';
import 'package:stoodee/utilities/reusables/reusable_stoodee_button.dart';
import 'package:stoodee/services/local_crud/crud_exceptions.dart';
import 'package:stoodee/utilities/page_utilities/flashcards/empty_flashcard_reader_scaffold.dart';
import 'package:stoodee/utilities/reusables/timer.dart';
import 'package:stoodee/utilities/snackbar/create_snackbar.dart';
import 'package:stoodee/utilities/theme/theme.dart';
import 'package:stoodee/utilities/page_utilities/flashcards/fc_rush_widdgets.dart';

//FIXME:

Future<void> showFinishScreen({
  required BuildContext context,
  required DatabaseUser user,
  required int score,
  required int missCount,
}) {
  String titleText = "Rush is over! Score: $score";
  String contentText =
      "You have achieved a score of $score points!\nWith a miss count of: $missCount.\nYour previous highscore was ${user.flashcardRushHighscore}.";

  if (score > user.flashcardRushHighscore) {
    titleText = "New highscore! Score: $score ";
    LocalDbController().updateUserFcRushHighscore(
      user: user,
      value: score,
    );
  }

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titleText),
        content: Text(contentText),
        actions: <Widget>[
          TextButton(
            child: const Text('Continue'),
            onPressed: () {
              goRouterToMain(context);
            },
          ),
        ],
      );
    },
  );
}

//FIXME:

class FlashCardsRush extends StatefulWidget {
  const FlashCardsRush({super.key, required this.flashcardSet});

  final DatabaseFlashcardSet flashcardSet;

  @override
  State<FlashCardsRush> createState() => _FlashCardsRushState();
}

class _FlashCardsRushState extends State<FlashCardsRush>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late Future<List<DatabaseFlashcard>> _loadFlashcardsFuture;

  @override
  void initState() {
    super.initState();
    imageCache.clear();

    _animationController =
        AnimationController(vsync: this, duration: Durations.extralong4);
    _loadFlashcardsFuture = FlashcardsService().loadFlashcardsFromSet(
      fcSet: widget.flashcardSet,
      mustBeActive: false,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void navigateToMain(BuildContext context) {
    goRouterToMain(context, "l");
  }

  int score = 0;
  int _completedCount = 0;
  bool _showNavigation = false;

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
                final List<DatabaseFlashcard> fcs = snapshot.data ?? [];
                final int totalFcsCount = fcs.length + _completedCount;

                if (totalFcsCount != 0 && _completedCount == totalFcsCount) {
                  _handleSetDone(context);
                  return Container(
                    color: usertheme.backgroundColor,
                  );
                } else {
                  return _buildFcRushScaffold(
                    context: context,
                    flashcards: fcs,
                    totalFlashcardsCount: totalFcsCount,
                  );
                }
              } on FlashcardListEmpty {
                _showEmptySetSnackbar(context);
                return EmptyReaderScaffold(fcset: widget.flashcardSet);
              }

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  void _handleSetDone(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigateToMain(context);
    });
  }

  void _showEmptySetSnackbar(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ScaffoldMessenger.of(context).showSnackBar(
        createErrorSnackbar(
            "Current set is empty. Add some flashcards before studying!"),
      ),
    );
  }

  Widget _buildFcRushScaffold({
    required BuildContext context,
    required List<DatabaseFlashcard> flashcards,
    required int totalFlashcardsCount,
  }) {
    return Scaffold(
      backgroundColor: usertheme.backgroundColor,
      appBar: CustomAppBar(
        leading: Text(
          widget.flashcardSet.name,
          style: TextStyle(color: usertheme.textColor),
        ),
        titleWidget: const Text(
          "-",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leftWidget: Text(
          "FlashcardRush",
          style: TextStyle(color: usertheme.textColor),
        ),
      ),
      body: Stack(
        children: [
          _buildFlashcardStack(
            totalFlashcardsCount: totalFlashcardsCount,
            flashcards: flashcards,
          ),
          IgnorePointer(
            child: Lottie.asset(
              alignment: Alignment.center,
              'lib/assets/sparkle.json',
              controller: _animationController,
              height: MediaQuery.of(context).size.height * 0.45,
              width: MediaQuery.of(context).size.width * 0.45,
              fit: BoxFit.cover,
              repeat: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashcardStack({
    required List<DatabaseFlashcard> flashcards,
    required int totalFlashcardsCount,
  }) {
    int missCount = 0;

    var fc = FlashcardsService().getRandFromList(
      fcList: flashcards,
      mustBeActive: false,
    );

    void handleCorrectButtonPress() {
      score++;
      _showNavigation = false;
      fc = FlashcardsService().getRandFromList(fcList: flashcards);
      setState(() {});
    }

    void handleWrongButtonPress() {
      missCount++;
      _showNavigation = false;
      fc = FlashcardsService().getRandFromList(fcList: flashcards);

      setState(() {});
    }

    FlipCard test;

    return Center(
      child: Column(
        children: [
          _buildReturnButton(),
          TimerWidget(
            startingseconds: 6,
            func: () async {
              await showFinishScreen(
                context: context,
                user: LocalDbController().currentUser,
                score: score,
                missCount: missCount,
              );
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 300,
            height: 300,
            child: FlipCard(
              speed: 250,
              onFlip: () {
                setState(() {
                  _showNavigation = true;
                });
              },
              side: CardSide.FRONT,
              direction: FlipDirection.HORIZONTAL,
              front: ReusableCard(
                text: fc.frontText,
              ),
              back: ReusableCard(
                text: fc.backText,
              ),
            ),
          ),
          Row(
            children: [
              Gap(MediaQuery.of(context).size.width * 0.2),
              Column(
                children: [
                  Text(
                    "Score:",
                    style: TextStyle(color: usertheme.textColor),
                  ),
                  Text(
                    "$score",
                    style: TextStyle(color: usertheme.textColor),
                  ),
                ],
              ),
              Expanded(
                flex: 3,
                child: Container(),
              ),
              buildMissCount(missCount),
              Expanded(flex: 2, child: Container()),
            ],
          ),
          const Expanded(child: Text("")),
          _buildDifficultyRow(
            currentFlashcard: fc,
            handleCorrectAnswerFunc: handleCorrectButtonPress,
            handleWrongAnswerFunc: handleWrongButtonPress,
          ),
        ],
      ),
    );
  }

  String getDisplayDateText(DateTime displayDate) {
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

  Widget _buildReturnButton() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: buildReturnButton(onPressed: () => navigateToMain(context)),
      ),
    );
  }

  Widget _buildDifficultyRow({
    required DatabaseFlashcard currentFlashcard,
    required Function handleWrongAnswerFunc,
    required Function handleCorrectAnswerFunc,
  }) {
    if (_showNavigation) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 120),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StoodeeButton(
                child: const Text("Wrong"),
                onPressed: () {
                  handleWrongAnswerFunc();
                }),
            StoodeeButton(
                child: const Text("Correct"),
                onPressed: () {
                  handleCorrectAnswerFunc();
                })
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildDifficultyButton({
    required String buttonText,
    required Function() onPressed,
    required String displayDateText,
  }) {
    return Column(
      children: [
        StoodeeButton(
          onPressed: onPressed,
          child: Text(buttonText, style: biggerButtonTextStyle),
        ),
        Text(
          displayDateText,
          style: TextStyle(color: usertheme.textColor),
        ),
      ],
    );
  }

  void _addProgress() {
    _completedCount++;
    setState(() {});
  }

  void _setNavigationFalse() {
    setState(() {
      _showNavigation = false;
    });
  }

  void _handleDifficultyButtonPress({
    required DatabaseFlashcard currentFlashcard,
    required int difficultyChange,
  }) async {
    _addProgress();
    _setNavigationFalse();

    await FlashcardsService().calcFcDisplayDate(
      fc: currentFlashcard,
      newDifficulty: currentFlashcard.cardDifficulty + difficultyChange,
    );

    await FlashcardsService().incrFcsCompleted();
  }
}

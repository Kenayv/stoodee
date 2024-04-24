import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:lottie/lottie.dart';
import 'package:stoodee/services/flashcards/fc_difficulty.dart';
import 'package:stoodee/services/flashcards/flashcard_service.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/services/router/route_functions.dart';
import 'package:stoodee/utilities/page_utilities/flashcards/fc_reader_widget.dart';
import 'package:stoodee/utilities/reusables/custom_appbar.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:stoodee/utilities/page_utilities/reusable_card.dart';
import 'package:stoodee/utilities/reusables/reusable_stoodee_button.dart';
import 'package:stoodee/services/local_crud/crud_exceptions.dart';
import 'package:stoodee/utilities/page_utilities/flashcards/empty_flashcard_reader_scaffold.dart';
import 'package:stoodee/utilities/snackbar/create_snackbar.dart';

class FlashCardsReader extends StatefulWidget {
  const FlashCardsReader({super.key, required this.flashcardSet});

  final DatabaseFlashcardSet flashcardSet;

  @override
  State<FlashCardsReader> createState() => _FlashCardsReaderState();
}

class _FlashCardsReaderState extends State<FlashCardsReader>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late Future<List<DatabaseFlashcard>> _loadFlashcardsFuture;

  @override
  void initState() {
    super.initState();
    imageCache.clear();

    _animationController =
        AnimationController(vsync: this, duration: Durations.extralong4);
    _loadFlashcardsFuture = FlashcardsService()
        .loadActiveFlashcardsFromSet(fcSet: widget.flashcardSet);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void navigateToMain(BuildContext context) {
    goRouterToMain(context, "l");
  }

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
                    color: const Color.fromRGBO(255, 255, 255, 1),
                  );
                } else {
                  final fc = FlashcardsService().getRandFromList(fcList: fcs);

                  return _buildFlashcardsScaffold(
                    context: context,
                    flashcards: fcs,
                    totalFlashcardsCount: totalFcsCount,
                    currentFlashcard: fc,
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

  Widget _buildFlashcardsScaffold({
    required BuildContext context,
    required List<DatabaseFlashcard> flashcards,
    required int totalFlashcardsCount,
    required DatabaseFlashcard currentFlashcard,
  }) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: const Text(''),
        titleWidget: Text(
          widget.flashcardSet.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          _buildFlashcardStack(
            currentFlashcard: currentFlashcard,
            totalFlashcardsCount: totalFlashcardsCount,
            removeFcFunction: () => flashcards.remove(currentFlashcard),
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
    required DatabaseFlashcard currentFlashcard,
    required int totalFlashcardsCount,
    required Function removeFcFunction,
  }) {
    return Center(
      child: Column(
        children: [
          _buildReturnButton(),
          buildProgressBar(
            completed: _completedCount,
            totalCount: totalFlashcardsCount,
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
                text: currentFlashcard.frontText,
              ),
              back: ReusableCard(
                text: currentFlashcard.backText,
              ),
            ),
          ),
          const Expanded(child: Text("")),
          _buildDifficultyRow(
            currentFlashcard: currentFlashcard,
            removeFcFunction: removeFcFunction,
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
    required Function removeFcFunction,
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
            _buildDifficultyButton(
              buttonText: "Easy",
              onPressed: () => _handleDifficultyButtonPress(
                currentFlashcard: currentFlashcard,
                difficultyChange: -1,
                removeFcFunction: removeFcFunction,
              ),
              displayDateText: getDisplayDateText(
                calculateDateToShowFc(
                    cardDifficulty: currentFlashcard.cardDifficulty - 1),
              ),
            ),
            _buildDifficultyButton(
              buttonText: "Medium",
              onPressed: () => _handleDifficultyButtonPress(
                currentFlashcard: currentFlashcard,
                difficultyChange: 0,
                removeFcFunction: removeFcFunction,
              ),
              displayDateText: getDisplayDateText(
                calculateDateToShowFc(
                    cardDifficulty: currentFlashcard.cardDifficulty),
              ),
            ),
            _buildDifficultyButton(
              buttonText: "Hard",
              onPressed: () => _handleDifficultyButtonPress(
                currentFlashcard: currentFlashcard,
                difficultyChange: 2,
                removeFcFunction: removeFcFunction,
              ),
              displayDateText: getDisplayDateText(
                calculateDateToShowFc(
                    cardDifficulty: currentFlashcard.cardDifficulty + 2),
              ),
            ),
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
        Text(displayDateText),
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
    required Function removeFcFunction,
  }) async {
    _addProgress();
    _setNavigationFalse();
    removeFcFunction();

    await FlashcardsService().calcFcDisplayDate(
      fc: currentFlashcard,
      newDifficulty: currentFlashcard.cardDifficulty + difficultyChange,
    );
  }
}

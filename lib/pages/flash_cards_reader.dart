import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:stoodee/localization/locales.dart';
import 'package:stoodee/services/flashcards/fc_difficulty.dart';
import 'package:stoodee/services/flashcards/flashcard_service.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/services/router/route_functions.dart';
import 'package:stoodee/utilities/page_utilities_and_widgets/flashcards/fc_reader_widget.dart';
import 'package:stoodee/utilities/reusables/custom_appbar.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:stoodee/utilities/page_utilities_and_widgets/reusable_card.dart';
import 'package:stoodee/utilities/reusables/page_scaffold.dart';
import 'package:stoodee/utilities/reusables/reusable_stoodee_button.dart';
import 'package:stoodee/services/local_crud/crud_exceptions.dart';
import 'package:stoodee/utilities/page_utilities_and_widgets/flashcards/empty_flashcard_reader_scaffold.dart';
import 'package:stoodee/utilities/snackbar/create_snackbar.dart';
import 'package:stoodee/utilities/theme/theme.dart';

import '../utilities/dialogs/are_you_sure_dialog.dart';

class FlashCardsReader extends StatefulWidget {
  const FlashCardsReader({super.key, required this.flashcardSet});

  final FlashcardSet flashcardSet;

  @override
  State<FlashCardsReader> createState() => _FlashCardsReaderState();
}

class _FlashCardsReaderState extends State<FlashCardsReader>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late Future<List<Flashcard>> _loadFlashcardsFuture;
  late Flashcard currentFlashcard;
  bool shouldRandomizeFc = true;

  late FlipCardController flipCardController;

  @override
  void initState() {
    super.initState();
    imageCache.clear();

    _animationController =
        AnimationController(vsync: this, duration: Durations.extralong4);
    _loadFlashcardsFuture = FlashcardsService().loadFlashcardsFromSet(
      fcSet: widget.flashcardSet,
      mustBeActive: true,
    );

    flipCardController = FlipCardController();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void navigateToMain(BuildContext context) {
    goRouterToMain(context, "l");

    WidgetsBinding.instance.addPostFrameCallback(
        (_) => (navigatorKey.currentWidget as BottomNavigationBar).onTap!(1));

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
      child: FutureBuilder<List<Flashcard>>(
        future: _loadFlashcardsFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              try {
                final List<Flashcard> fcs = snapshot.data ?? [];
                final int totalFcsCount = fcs.length + _completedCount;

                if (totalFcsCount != 0 && _completedCount == totalFcsCount) {
                  _handleSetDone(context);
                  return Container(
                    color: usertheme.backgroundColor,
                  );
                } else {
                  if (shouldRandomizeFc) {
                    currentFlashcard = FlashcardsService().getRandFromList(
                      fcList: fcs,
                      mustBeActive: false,
                    );
                    shouldRandomizeFc = false;
                  }

                  return _buildFlashcardsScaffold(
                    context: context,
                    flashcards: fcs,
                    totalFlashcardsCount: totalFcsCount,
                    currentFlashcard: currentFlashcard,
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
            LocaleData.snackBarSetEmpty.getString(context)),
      ),
    );
  }

  Future<void> deleteFlashcardFunc({
    required Flashcard flashcard,
    required List<Flashcard> flashcards,
  }) async {
    await FlashcardsService().removeFlashcard(flashcard: flashcard);
    flashcards.removeWhere((fc) => fc.id == flashcard.id);
    shouldRandomizeFc = true;

    await FlashcardsService().reloadFlashcardSets();
  }

  Widget _buildFlashcardsScaffold({
    required BuildContext context,
    required List<Flashcard> flashcards,
    required int totalFlashcardsCount,
    required Flashcard currentFlashcard,
  }) {
    return Scaffold(
      backgroundColor: usertheme.backgroundColor,
      appBar: CustomAppBar(
        leading: const Text(''),
        titleWidget: Text(
          widget.flashcardSet.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leftWidget: ElevatedButton(
          child: Text(LocaleData.fcReaderDeleteButton.getString(context)),
          onPressed: () async {
            await showDeleteFcDialog(
                context: context,
                fun: () async {
                  await deleteFlashcardFunc(
                    flashcard: currentFlashcard,
                    flashcards: flashcards,
                  );
                  setState(() {});
                });

            setState(() {});
          },
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
    required Flashcard currentFlashcard,
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
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.38,
            child: FlipCard(
              controller: flipCardController,
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
      return "${difference.inDays} ${difference.inDays > 1 ? LocaleData.accountDays.getString(context) : LocaleData.accountDay.getString(context)}";
    } else if (difference.inHours > 1) {
      return "${difference.inHours}h ${difference.inHours > 1 ? LocaleData.fcreaderHours.getString(context) : LocaleData.fcreaderHour.getString(context)}";
    } else if (difference.inMinutes > 1) {
      return "${difference.inMinutes}  ${difference.inMinutes > 1 ? LocaleData.fcreaderMinutes.getString(context) : LocaleData.fcreaderMinute.getString(context)}";
    } else {
      return "1 ${LocaleData.fcreaderMinute.getString(context)}";
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
    required Flashcard currentFlashcard,
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
              buttonText: LocaleData.fcreaderEasy.getString(context),
              onPressed: () => _handleDifficultyButtonPress(
                currentFlashcard: currentFlashcard,
                difficultyChange: -1,
                removeFcFunction: removeFcFunction,
              ),
              displayDateText: getDisplayDateText(
                calculateFcDisplayDate(
                    cardDifficulty: currentFlashcard.cardDifficulty - 1),
              ),
            ),
            _buildDifficultyButton(
              buttonText: LocaleData.fcreaderMedium.getString(context),
              onPressed: () => _handleDifficultyButtonPress(
                currentFlashcard: currentFlashcard,
                difficultyChange: 0,
                removeFcFunction: removeFcFunction,
              ),
              displayDateText: getDisplayDateText(
                calculateFcDisplayDate(
                    cardDifficulty: currentFlashcard.cardDifficulty),
              ),
            ),
            _buildDifficultyButton(
              buttonText: LocaleData.fcreaderHard.getString(context),
              onPressed: () => _handleDifficultyButtonPress(
                currentFlashcard: currentFlashcard,
                difficultyChange: 2,
                removeFcFunction: removeFcFunction,
              ),
              displayDateText: getDisplayDateText(
                calculateFcDisplayDate(
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
        Text(LocaleData.fcreaderShowAfter.getString(context),style: TextStyle(color: usertheme.textColor.withOpacity(0.6),),),
        Text(
          displayDateText,
          style: TextStyle(color: usertheme.textColor,fontWeight: FontWeight.bold),
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
    required Flashcard currentFlashcard,
    required int difficultyChange,
    required Function removeFcFunction,
  }) async {
    if (!flipCardController.state!.isFront) {
      flipCardController.toggleCardWithoutAnimation();
      _showNavigation = false;
    }

    shouldRandomizeFc = true;
    _addProgress();
    _setNavigationFalse();
    removeFcFunction();

    await FlashcardsService().calcFcDisplayDate(
      fc: currentFlashcard,
      newDifficulty: currentFlashcard.cardDifficulty + difficultyChange,
    );

    await FlashcardsService().incrFcsCompleted();
  }
}

import 'dart:async';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:stoodee/localization/locales.dart';
import 'package:stoodee/services/flashcards/flashcard_service.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/services/router/route_functions.dart';
import 'package:stoodee/utilities/page_utilities_and_widgets/flashcards/fc_reader_widget.dart';
import 'package:stoodee/utilities/page_utilities_and_widgets/flashcards/fc_rush_finish_screen.dart';
import 'package:stoodee/utilities/reusables/custom_appbar.dart';
import 'package:stoodee/utilities/page_utilities_and_widgets/reusable_card.dart';
import 'package:stoodee/utilities/reusables/reusable_stoodee_button.dart';
import 'package:stoodee/services/local_crud/crud_exceptions.dart';
import 'package:stoodee/utilities/page_utilities_and_widgets/flashcards/empty_flashcard_reader_scaffold.dart';
import 'package:stoodee/utilities/reusables/timer.dart';
import 'package:stoodee/utilities/snackbar/create_snackbar.dart';
import 'package:stoodee/utilities/theme/theme.dart';
import 'package:stoodee/utilities/page_utilities_and_widgets/flashcards/fc_rush_widdgets.dart';

class FlashCardsRush extends StatefulWidget {
  const FlashCardsRush({
    super.key,
    required this.flashcardSet,
  });

  final FlashcardSet flashcardSet;

  @override
  State<FlashCardsRush> createState() => _FlashCardsRushState();
}

class _FlashCardsRushState extends State<FlashCardsRush>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late Future<List<Flashcard>> _loadFlashcardsFuture;
  late Flashcard currentFlashcard;
  bool shouldRandomizeFc = true;
  int missCount = 0;

  late FlipCardController flipCardController;
  void incrMissCount() => missCount++;

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

    flipCardController = FlipCardController();
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
  bool _showNavigation = false;

  @override
  Widget build(BuildContext context) {
    if (missCount >= 3) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showFinishScreen(
          context: context,
          user: LocalDbController().currentUser,
          score: score,
          missCount: missCount,
        );
      });
      return GestureDetector(
          onTap:(){
            goRouterToMain(context);

      } ,
          child:Container(color: usertheme.backgroundColor));
    }
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

                if (shouldRandomizeFc) {
                  currentFlashcard = FlashcardsService().getRandFromList(
                    fcList: fcs,
                    mustBeActive: false,
                  );
                  shouldRandomizeFc = false;
                }
                return _buildFcRushScaffold(
                  context: context,
                  flashcard: currentFlashcard,
                );
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

  void _showEmptySetSnackbar(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ScaffoldMessenger.of(context).showSnackBar(
        createErrorSnackbar(
            LocaleData.snackBarSetEmpty.getString(context)),
      ),
    );
  }

  Widget _buildFcRushScaffold({
    required BuildContext context,
    required Flashcard flashcard,
  }) {
    return Scaffold(
      backgroundColor: usertheme.backgroundColor,
      appBar: CustomAppBar(
        leading: Text(
          widget.flashcardSet.name,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        titleWidget: const Text(
          "-",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leftWidget: const Text(
          "FlashcardRush",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          _buildFlashcardStack(flashcard: flashcard),
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
    required Flashcard flashcard,
  }) {
    void handleCorrectButtonPress() {
      score++;
      _showNavigation = false;

      if (!flipCardController.state!.isFront) {
        flipCardController.toggleCardWithoutAnimation();
        _showNavigation = false;
      }

      setState(() {});
    }

    void handleWrongButtonPress() {
      incrMissCount();
      _showNavigation = false;

      if (!flipCardController.state!.isFront) {
        flipCardController.toggleCardWithoutAnimation();
        _showNavigation = false;
      }

      setState(() {});
    }

    return Center(
      child: Column(
        children: [
          _buildReturnButton(),
          TimerWidget(
            startingseconds: 90,
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
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.41,
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
                text: flashcard.frontText,
              ),
              back: ReusableCard(
                text: flashcard.backText,
              ),
            ),
          ),
          Row(
            children: [
              Gap(MediaQuery.of(context).size.width * 0.2),
              Column(
                children: [
                  Text(
                    LocaleData.fcRushScore.getString(context),
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
              buildMissCount(missCount,context),
              Expanded(flex: 2, child: Container()),
            ],
          ),
          const Expanded(child: Text("")),
          _buildDifficultyRow(
            currentFlashcard: flashcard,
            handleCorrectAnswerFunc: handleCorrectButtonPress,
            handleWrongAnswerFunc: handleWrongButtonPress,
            context: context,
          ),
        ],
      ),
    );
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
    required Function handleWrongAnswerFunc,
    required Function handleCorrectAnswerFunc,
    required BuildContext context,
  }) {
    double textSize = 25;

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
                child: Text(
                  LocaleData.fcRushWrong.getString(context),
                  style: TextStyle(color: Colors.white, fontSize: textSize),
                ),
                onPressed: () {
                  handleWrongAnswerFunc();
                  shouldRandomizeFc = true;
                }),
            StoodeeButton(
                child: Text(LocaleData.fcRushCorrect.getString(context),
                    style: TextStyle(color: Colors.white, fontSize: textSize)),
                onPressed: () {
                  handleCorrectAnswerFunc();
                  shouldRandomizeFc = true;
                })
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

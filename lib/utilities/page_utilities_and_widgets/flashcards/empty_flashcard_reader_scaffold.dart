import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:stoodee/localization/locales.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/services/router/route_functions.dart';
import 'package:stoodee/utilities/page_utilities_and_widgets/reusable_card.dart';
import 'package:stoodee/utilities/reusables/reusable_stoodee_button.dart';
import 'package:stoodee/utilities/snackbar/create_snackbar.dart';
import 'package:stoodee/utilities/dialogs/add_flashcard_dialog.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:stoodee/utilities/theme/theme.dart';
import 'package:stoodee/utilities/reusables/custom_appbar.dart';

Container _buildReturnButton(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(8),
    child: Align(
      alignment: Alignment.bottomLeft,
      child: StoodeeButton(
        onPressed: () => goRouterToMain(context),
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
    ),
  );
}

class EmptyReaderScaffold extends StatefulWidget {
  const EmptyReaderScaffold({super.key, required this.fcset});

  final FlashcardSet fcset;

  @override
  State<EmptyReaderScaffold> createState() => _EmptyReaderScaffoldState();
}

class _EmptyReaderScaffoldState extends State<EmptyReaderScaffold> {
  late final currentSet = widget.fcset;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: usertheme.backgroundColor,
      appBar: CustomAppBar(
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
                _buildReturnButton(context),
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Text(
                    LocaleData.fcEmptyReaderempty.getString(context),
                    style: TextStyle(color: usertheme.textColor),
                  ),
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
                    front: ReusableCard(
                      text: LocaleData.fcEmptyReaderFrontText.getString(context),
                    ),
                    back: ReusableCard(
                      text: LocaleData.fcEmptyReaderBackText.getString(context),
                    ),
                  ),
                ),
                StoodeeButton(
                  onPressed: () async {
                    await showAddFlashcardDialog(
                      context: context,
                      fcSet: currentSet,
                    );

                    if (currentSet.pairCount > 0) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              createSuccessSnackbar(LocaleData.snackBarFlashcardAdded.getString(context)));
                          goRouterToMain(context);
                        },
                      );
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            createErrorSnackbar(LocaleData.snackBarFlashcarNotAdded.getString(context)),
                          );
                        },
                      );
                    }
                  },
                  child: Text(
                    LocaleData.fcEmptyReaderAddFlashcard.getString(context),
                    style: buttonTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

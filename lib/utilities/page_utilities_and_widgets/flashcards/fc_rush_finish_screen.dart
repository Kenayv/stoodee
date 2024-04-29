import 'package:flutter/material.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_user.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/services/router/route_functions.dart';

Future<void> showFinishScreen({
  required BuildContext context,
  required User user,
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

    user.setFlashcardRushHighscore(score);
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

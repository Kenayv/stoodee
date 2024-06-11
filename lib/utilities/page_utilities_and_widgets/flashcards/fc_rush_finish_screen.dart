import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:stoodee/localization/locales.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_user.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/services/router/route_functions.dart';
import 'package:stoodee/utilities/theme/theme.dart';

Future<void> showFinishScreen({
  required BuildContext context,
  required User user,
  required int score,
  required int missCount,
}) {
  String titleText = "${LocaleData.dialogRushIsOver.getString(context)} $score";
  String contentText = context.formatString(LocaleData.dialogRushOverDescripiton, [score,missCount,user.flashcardRushHighscore]);
      //"You have achieved a score of $score points!\nWith a miss count of: $missCount.\nYour previous highscore was ${user.flashcardRushHighscore}.";

  if (!LocalDbController().isNullUser(user)) {
    if (score > user.flashcardRushHighscore) {
      titleText = "${LocaleData.dialogNewHighScore.getString(context)} $score ";
      LocalDbController().updateUserFcRushHighscore(
        user: user,
        value: score,
      );

      user.setFlashcardRushHighscore(score);
    }
  }

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: usertheme.backgroundColor,
        title: Text(titleText,style: TextStyle(color: usertheme.textColor),),
        content: Text(contentText,style: TextStyle(color: usertheme.textColor),),
        actions: <Widget>[
          TextButton(
            child: Text(LocaleData.dialogContinue.getString(context),style: TextStyle(color: usertheme.textColor),),
            onPressed: () {
              goRouterToMain(context);
            },
          ),
        ],
      );
    },
  );
}

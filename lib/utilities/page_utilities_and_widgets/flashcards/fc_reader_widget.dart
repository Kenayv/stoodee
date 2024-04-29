import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:stoodee/utilities/reusables/reusable_stoodee_button.dart';
import 'package:stoodee/utilities/theme/theme.dart';

StoodeeButton buildReturnButton({required void Function() onPressed}) {
  return StoodeeButton(
    onPressed: onPressed,
    child: const Icon(Icons.arrow_back, color: Colors.white),
  );
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

Column buildProgressBar({
  required int completed,
  required int totalCount,
}) {
  return Column(
    children: [
      Container(
        margin: const EdgeInsets.only(top: 15),
        child: Text("$completed/$totalCount",
            style: TextStyle(color: usertheme.textColor)),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: LinearPercentIndicator(
            backgroundColor: usertheme.analogousColor.withOpacity(0.08),
            percent: isNotZero(completed, totalCount),
            linearGradient: LinearGradient(
              colors: [usertheme.primaryAppColor, usertheme.analogousColor],
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
    ],
  );
}

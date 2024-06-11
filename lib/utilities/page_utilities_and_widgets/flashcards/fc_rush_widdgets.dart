import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:stoodee/localization/locales.dart';
import 'package:stoodee/utilities/theme/theme.dart';

Container buildTimer() {
  Container container = Container();

  return container;
}

Column buildMissCount(int count,BuildContext context) {
  return Column(
    children: [
      Text(LocaleData.fcRushMisses.getString(context), style: TextStyle(color: usertheme.textColor)),
      Row(
        children: [
          for (int i = 0; i < count; i++)
            const Icon(
              Icons.close,
              color: Colors.red,
            ),
          if (count == 0)
            Text(LocaleData.fcRushMissesNone.getString(context), style: TextStyle(color: usertheme.textColor))
        ],
      ),
    ],
  );
}

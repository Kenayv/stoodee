import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:gap/gap.dart';
import 'package:stoodee/localization/locales.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/utilities/page_utilities_and_widgets/mainpage_widgets.dart';
import 'package:stoodee/utilities/theme/theme.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = LocalDbController().currentUser;
    return Scaffold(
      backgroundColor: usertheme.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Gap(MediaQuery.of(context).size.width * 0.03),
            Text(
              "Stoodee",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: usertheme.textColor),
            ),
            Text(
              LocaleData.mainDidYouKnow.getString(context),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
            const Gap(5),
            buildFunFactBox(context: context),
            const Gap(25),
            Text(LocaleData.mainTodaysGoal.getString(context),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: usertheme.textColor)),
            buildGaugeRow(context, currentUser),
            const Gap(25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  LocaleData.mainCurrentDaysStreak.getString(context),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: usertheme.textColor),
                ),
              ],
            ),
            buildStreakGauge(context: context, user: currentUser)
          ],
        ),
      ),
    );
  }
}

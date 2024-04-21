import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stoodee/services/auth/auth_service.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_user.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/services/router/route_functions.dart';
import 'package:stoodee/services/shared_prefs/shared_prefs.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:stoodee/utilities/reusables/reusable_stoodee_button.dart';

StoodeeButton buildLoginOrLogoutButton(BuildContext context) {
  if (AuthService.firebase().currentUser == null) {
    return StoodeeButton(
        onPressed: () async {
          await SharedPrefs().setRememberLogin(value: false);
          goRouterToLogin(context);
        },
        child: Text("Log-in", style: buttonTextStyle));
  } else {
    return StoodeeButton(
      onPressed: () async {
        await SharedPrefs().setRememberLogin(value: false);
        await AuthService.firebase().logOut();
        final loggedOutUser = await LocalDbController().getNullUser();
        await LocalDbController().setCurrentUser(loggedOutUser);
        goRouterToLogin(context);
      },
      child: Text(
        "Log-out",
        style: buttonTextStyle,
      ),
    );
  }
}

Container buildStatsContainer(DatabaseUser user) {
  return Container(
    padding: const EdgeInsets.all(5),
    width: double.infinity,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(1, 1),
          )
        ]),
    child: Column(
      children: [
        buildStatItem('Obecny Streak', "!placeholder!"),
        buildStatItem('Ukończone zadania', "!placeholder!"),
        buildStatItem('Nieukończone zadania', "!placeholder!"),
        buildStatItem('Wykonanych zadań', "!placeholder!"),
        buildStatItem('Rekord Fiszki Rush', "!placeholder!"),
        buildStatItem('Ukończone Fiszki', "!placeholder!"),
        buildStatItem('Najdłuższy Streak', "!placeholder!"),
      ],
    ),
  );
}

Padding buildStatItem(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 1.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "$title:",
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        const Gap(20),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}

Align buildProfilePic(BuildContext context) {
  double imgSize = MediaQuery.of(context).size.height * 0.15;
  return Align(
    alignment: Alignment.center,
    child: Image.asset(
      'lib/assets/BurnOutSorry.png',
      width: imgSize,
      height: imgSize,
    ),
  );
}

Text buildUsername(DatabaseUser user) {
  return Text(
    user.name,
    style: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  );
}

Align buildSettingsButton({required Function onPressed}) {
  return Align(
    alignment: Alignment.topRight,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: StoodeeButton(
          onPressed: () => onPressed,
          child: const Icon(
            Icons.settings,
            color: Colors.white,
          )),
    ),
  );
}

StoodeeButton buildSyncWithCloudButton(DatabaseUser user) {
  return StoodeeButton(
    child: const Icon(Icons.sync, color: Colors.white),
    onPressed: () async {
      await LocalDbController().syncWithCloud(user: user);
    },
  );
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stoodee/services/auth/auth_service.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/services/router/route_functions.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:stoodee/utilities/reusables/reusable_stoodee_button.dart';
import 'package:stoodee/utilities/dialogs/add_task_dialog.dart';
import 'package:stoodee/services/shared_prefs/shared_prefs.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({
    super.key,
  });

  @override
  State<AccountPage> createState() => _AccountPage();
}

class _AccountPage extends State<AccountPage> {
  void nothing() {
    log("nothing");
  }

  StoodeeButton resolveWhichButton() {
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
          child: Text("Log-out", style: buttonTextStyle));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Gap(10),
            Stack(children: [
              Align(
                  alignment: Alignment.center,
                  child: Image.asset('lib/assets/BurnOutSorry.png',
                      width: 200, height: 200)),
              Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: StoodeeButton(
                        onPressed: nothing,
                        child: const Icon(
                          Icons.settings,
                          color: Colors.white,
                        )),
                  ))
            ]),
            const Gap(30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                        )
                      ]),
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: const Text("stats placeholder")),
            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(width: MediaQuery.of(context).size.width * 0.2),
                resolveWhichButton(),
                StoodeeButton(
                  child: const Icon(Icons.sync, color: Colors.white),
                  onPressed: () {
                    showAddTaskDialog(context: context);
                  },
                ),
              ],
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stoodee/services/auth/auth_service.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/services/router/route_functions.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:stoodee/utilities/reusables/reusable_stoodee_button.dart';
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
    double imgSize=MediaQuery.of(context).size.height*0.15;
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
                      width: imgSize, height: imgSize)),
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
              child:Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Text("!username!",style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),)),



                    const Center(
                      child: Text(
                        'Statystyki:',

                      ),
                    ),
                    const Divider(color: Colors.grey,thickness: 2,),

                    const Gap(15),
                    Container(
                        padding: const EdgeInsets.all(5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(1,1),
                              )
                            ]),

                        child: Column(
                          children: [
                            buildStatItem('Obecny Streak',"!placeholder!"),
                            buildStatItem('Ukończone zadania',"!placeholder!"),
                            buildStatItem('Nieukończone zadania',"!placeholder!"),
                            buildStatItem('Wykonanych zadań',"!placeholder!"),
                            buildStatItem('Rekord Fiszki Rush',"!placeholder!"),
                            buildStatItem('Ukończone Fiszki',"!placeholder!"),
                            buildStatItem('Najdłuższy Streak', "!placeholder!"),
                          ],
                        )

                    )],
                ),
              ),
            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(width: MediaQuery.of(context).size.width * 0.2),
                resolveWhichButton(),
                StoodeeButton(
                  child: const Icon(Icons.sync, color: Colors.white),
                  onPressed: () async {
                    final user = LocalDbController().currentUser;
                    await LocalDbController().syncWithCloud(user: user);
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




Widget buildStatItem(String title, String value) {
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
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/utilities/page_utilities/account_widgets.dart';

void nothing() {/*FIXME: delete */}

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPage();
}

class _AccountPage extends State<AccountPage> {
  final currentUser = LocalDbController().currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Gap(10),
            Stack(
              children: [
                buildProfilePic(context),
                buildSettingsButton(onPressed: nothing),
              ],
            ),
            const Gap(30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: buildUsername(currentUser)),
                    const Center(child: Text('Statystyki:')),
                    const Divider(color: Colors.grey, thickness: 2),
                    const Gap(15),
                    buildStatsContainer(currentUser),
                  ],
                ),
              ),
            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(width: MediaQuery.of(context).size.width * 0.2),
                buildLoginOrLogoutButton(context),
                buildSyncWithCloudButton(currentUser),
              ],
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}

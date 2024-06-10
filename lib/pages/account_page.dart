import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:gap/gap.dart';
import 'package:stoodee/localization/locales.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/utilities/dialogs/user_settings_dialog.dart';
import 'package:stoodee/utilities/page_utilities_and_widgets/account_widgets.dart';
import 'package:stoodee/utilities/snackbar/create_snackbar.dart';
import 'package:stoodee/utilities/theme/theme.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPage();
}

class _AccountPage extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = LocalDbController().currentUser;
    return Scaffold(
      backgroundColor: usertheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Gap(10),
            Stack(
              children: [
                buildCountryFlags(context),
                buildProfilePic(context),
                buildSettingsButton(
                  onPressed: () async {
                    if (LocalDbController().isNullUser(currentUser)) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(createErrorSnackbar("Log-in first"));
                    } else {
                      await showUserSettingsDialog(
                        context: context,
                        user: currentUser,
                      );
                      setState(() {});
                    }
                  },
                ),
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
                    Center(
                        child: Text(
                      LocaleData.accountYourStats.getString(context),
                      style: const TextStyle(color: Colors.grey),
                    )),
                    const Divider(color: Colors.grey, thickness: 2),
                    const Gap(15),
                    buildStatsContainer(currentUser, context),
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
                buildSyncWithCloudButton(context),
              ],
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}

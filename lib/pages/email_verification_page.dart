import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:stoodee/localization/locales.dart';
import 'package:stoodee/services/auth/auth_service.dart';
import 'package:stoodee/services/router/route_functions.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleData.emailVerifTitle.getString(context))),
      body: Column(
        children: [
          Text(LocaleData.emailVerifDesc1.getString(context)),
          Text(LocaleData.emailVerifDesc2.getString(context)),
          Text(LocaleData.emailVerifDesc3.getString(context)),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            },
            child: Text(
              LocaleData.emailVerifDontSeeLink.getString(context),
            ),
          ),
          TextButton(
            onPressed: () async {
              AuthService.firebase().logOut();
              goRouterToLogin(context);
            },
            child: Text(LocaleData.loginTitle.getString(context)),
          ),
        ],
      ),
    );
  }
}

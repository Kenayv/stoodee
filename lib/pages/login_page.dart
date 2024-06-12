import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:gap/gap.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:stoodee/utilities/page_utilities_and_widgets/login_widgets.dart';
import 'package:stoodee/utilities/theme/theme.dart';

import '../localization/locales.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool rememberBool = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: usertheme.backgroundColor,
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: buildSkipLoginButton(context),
                  )
                ],
              ),
              Expanded(flex: 1, child: Container()),
              Gap(MediaQuery.of(context).size.height * 0.01),
              Image.asset(
                'lib/assets/BaseLogoSwanResized.png',
                width: 140,
                height: 140,
              ),
              const Gap(25),
              buildWelcomeAnimation(context),
              const Gap(10),
              Text(
                LocaleData.loginTitle.getString(context),
                style: const TextStyle(color: Colors.grey),
              ),
              buildEmailInput(emailController, context),
              buildPasswordInput(passwordController, context),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(LocaleData.loginRememberMe.getString(context),
                      style: TextStyle(color: Colors.grey.shade400)),
                  Checkbox(
                    value: rememberBool,
                    onChanged: (newValue) {
                      setState(() {
                        rememberBool = newValue!;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    side: MaterialStateBorderSide.resolveWith(
                      (states) => const BorderSide(
                        width: 2.0,
                        color: primaryAppColor,
                      ),
                    ),
                  ),
                  const Gap(20),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildSignUpButton(
                    context: context,
                    email: emailController.text,
                    password: passwordController.text,
                    remember: rememberBool,
                  ),
                  buildSignInButton(
                    context: context,
                    email: emailController.text,
                    password: passwordController.text,
                    remember: rememberBool,
                  ),
                ],
              ),
              Expanded(flex: 3, child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}

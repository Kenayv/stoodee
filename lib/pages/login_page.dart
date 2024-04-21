import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stoodee/utilities/pages_widgets/login_widgets.dart';

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
              buildWelcomeAnimation(),
              const Gap(10),
              const Text("Log-in s", style: TextStyle(color: Colors.grey)),
              buildEmailInput(emailController),
              buildPasswordInput(passwordController),
              buildRememberMeCheckbox(rememberBool),
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

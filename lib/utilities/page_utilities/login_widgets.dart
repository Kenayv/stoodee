// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:stoodee/services/auth/auth_exceptions.dart';
import 'package:stoodee/services/auth/auth_service.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/services/router/route_functions.dart';
import 'package:stoodee/services/shared_prefs/shared_prefs.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:stoodee/utilities/reusables/reusable_stoodee_button.dart';
import 'package:stoodee/utilities/snackbar/create_snackbar.dart';
import 'package:stoodee/utilities/theme/theme.dart';

SizedBox buildWelcomeAnimation() {
  return SizedBox(
    height: 35,
    child: DefaultTextStyle(
      style: const TextStyle(
        color: primaryAppColor,
        fontSize: 20,
        fontWeight: FontWeight.w900,
      ),
      child: AnimatedTextKit(
        displayFullTextOnTap: true,
        repeatForever: false,
        isRepeatingAnimation: false,
        animatedTexts: [
          TypewriterAnimatedText('Thanks for being with us :D',
              speed: const Duration(milliseconds: 150),
              curve: Curves.decelerate,
              textStyle: TextStyle(color:usertheme.textColor),
              cursor: "|"),
          TypewriterAnimatedText('It means a lot! ^^',
              speed: const Duration(milliseconds: 100),
              textStyle: TextStyle(color:usertheme.textColor),
              curve: Curves.decelerate,
              cursor: "|"),
          TypewriterAnimatedText('~Stoodee team',
              speed: const Duration(milliseconds: 100),
              textStyle: TextStyle(color:usertheme.textColor),
              curve: Curves.decelerate,
              cursor: "|"),
        ],
      ),
    ),
  );
}

Padding buildEmailInput(TextEditingController emailController) {
  return Padding(
    padding:
        const EdgeInsets.only(left: 25.0, right: 25.0, top: 10, bottom: 25),
    child: TextField(
      textInputAction: TextInputAction.next,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: 'E-mail',
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryAppColor),
        ),
        fillColor: Colors.grey.shade200,
        filled: true,
      ),
      controller: emailController,
    ),
  );
}

Padding buildPasswordInput(TextEditingController passwordController) {
  return Padding(
    padding: const EdgeInsets.only(top: 15.0, left: 25, right: 25, bottom: 5),
    child: TextField(
      textInputAction: TextInputAction.done,
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: 'Password',
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryAppColor),
        ),
        fillColor: Colors.grey.shade200,
        filled: true,
      ),
      controller: passwordController,
    ),
  );
}

Future<void> _signUp(String email, String password) =>
    AuthService.firebase().createUser(email: email, password: password);

Future<void> _signIn(String email, String password) =>
    AuthService.firebase().logIn(email: email, password: password);

StoodeeButton buildSignUpButton({
  required BuildContext context,
  required String email,
  required String password,
  required bool remember,
}) {
  return StoodeeButton(
    onPressed: () async {
      try {
        await _signUp(
          email,
          password,
        );
        await SharedPrefs().setRememberLogin(
          value: remember,
        );

        await AuthService.firebase().sendEmailVerification();
        goRouterToEmailVerification(context);
      } on EmailAlreadyInUseAuthException {
        ScaffoldMessenger.of(context).showSnackBar(
          createErrorSnackbar(
              "Account with this e-mail addresss already exists"),
        );
      } on InvalidEmailAuthException {
        ScaffoldMessenger.of(context).showSnackBar(
          createErrorSnackbar("Incorrect email entered"),
        );
      } on GenericAuthException {
        ScaffoldMessenger.of(context).showSnackBar(
          createErrorSnackbar("Enter email and password to Sign-Up"),
        );
      } on WeakPasswordAuthException {
        ScaffoldMessenger.of(context).showSnackBar(
          createErrorSnackbar("Password must contain at least 8 characters"),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          createErrorSnackbar(e.toString()),
        );
      }
    },
    child: Text(
      'Sign-up',
      style: buttonTextStyle,
    ),
  );
}

StoodeeButton buildSignInButton({
  required BuildContext context,
  required String email,
  required String password,
  required bool remember,
}) {
  return StoodeeButton(
    onPressed: () async {
      try {
        await _signIn(
          email,
          password,
        );

        await SharedPrefs().setRememberLogin(value: remember);

        if (AuthService.firebase().currentUser == null) {
          throw UserNotLoggedInAuthException();
        }

        //FIXME: DEBUG LOG
        log('Logging in with: ${LocalDbController().currentUser}');

        if (!AuthService.firebase().currentUser!.isEmailVerified) {
          goRouterToEmailVerification(context);
        } else {
          goRouterToMain(context);
        }
      } on InvalidCredentialsAuthException {
        ScaffoldMessenger.of(context)
            .showSnackBar(createErrorSnackbar("Incorrect email or password"));
      } on GenericAuthException {
        ScaffoldMessenger.of(context).showSnackBar(
            createErrorSnackbar("Enter email and password to log-in"));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(createErrorSnackbar(e.toString()));
      }
    },
    child: Text('Log-in', style: buttonTextStyle),
  );
}

GestureDetector buildSkipLoginButton(BuildContext context) {
  return GestureDetector(
    onTap: () => goRouterToMain(context),
    child: Text(
      "skip log-in",
      style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade400,
          decoration: TextDecoration.underline,
          decorationColor: Colors.grey.shade400),
    ),
  );
}

// ignore_for_file: use_build_context_synchronously

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:stoodee/services/auth/auth_exceptions.dart';
import 'package:stoodee/services/auth/auth_service.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'package:stoodee/services/router/route_functions.dart';
import 'package:stoodee/services/shared_prefs/shared_prefs.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:stoodee/utilities/reusables/reusable_stoodee_button.dart';
import 'package:stoodee/utilities/snackbar/create_snackbar.dart';
import 'package:stoodee/utilities/theme/theme.dart';

import '../../localization/locales.dart';

SizedBox buildWelcomeAnimation(BuildContext context) {
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
          TypewriterAnimatedText(LocaleData.loginTypewriter1.getString(context),
              speed: const Duration(milliseconds: 150),
              curve: Curves.decelerate,
              textStyle: TextStyle(color: usertheme.textColor),
              cursor: "|"),
          TypewriterAnimatedText(LocaleData.loginTypewriter2.getString(context),
              speed: const Duration(milliseconds: 100),
              textStyle: TextStyle(color: usertheme.textColor),
              curve: Curves.decelerate,
              cursor: "|"),
          TypewriterAnimatedText(LocaleData.loginTypewriter3.getString(context),
              speed: const Duration(milliseconds: 100),
              textStyle: TextStyle(color: usertheme.textColor),
              curve: Curves.decelerate,
              cursor: "|"),
        ],
      ),
    ),
  );
}

Padding buildEmailInput(TextEditingController emailController,BuildContext context) {
  return Padding(
    padding:
        const EdgeInsets.only(left: 25.0, right: 25.0, top: 10, bottom: 25),
    child: TextField(
      textInputAction: TextInputAction.next,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: LocaleData.loginHintEmail.getString(context),
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

Padding buildPasswordInput(TextEditingController passwordController,BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 15.0, left: 25, right: 25, bottom: 5),
    child: TextField(
      textInputAction: TextInputAction.done,
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: LocaleData.loginHintPassword.getString(context),
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
              LocaleData.snackBarAccountAlreadyExists.getString(context)),
        );
      } on InvalidEmailAuthException {
        ScaffoldMessenger.of(context).showSnackBar(
          createErrorSnackbar(LocaleData.snackBarIncorrectEmail.getString(context)),
        );
      } on GenericAuthException {
        ScaffoldMessenger.of(context).showSnackBar(
          createErrorSnackbar(LocaleData.snackBarEmailAndPassword.getString(context)),
        );
      } on WeakPasswordAuthException {
        ScaffoldMessenger.of(context).showSnackBar(
          createErrorSnackbar(LocaleData.snackBarPassword.getString(context)),
        );
      } on NoNetworkConnectionException {
        ScaffoldMessenger.of(context).showSnackBar(
            createErrorSnackbar(LocaleData.snackBarNoInternet.getString(context)));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          createErrorSnackbar(e.toString()),
        );
      }
    },
    child: Text(
      LocaleData.loginSignUp.getString(context),
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

        if (!AuthService.firebase().currentUser!.isEmailVerified) {
          goRouterToEmailVerification(context);
        } else {
          goRouterToMain(context);
        }
      } on InvalidCredentialsAuthException {
        ScaffoldMessenger.of(context)
            .showSnackBar(createErrorSnackbar(LocaleData.snackBarIncorrectEmail.getString(context)));
      } on GenericAuthException {
        ScaffoldMessenger.of(context).showSnackBar(
            createErrorSnackbar(LocaleData.snackBarEmailAndPassword.getString(context)));
      } on NoNetworkConnectionException {
        ScaffoldMessenger.of(context).showSnackBar(
            createErrorSnackbar(LocaleData.snackBarNoInternet.getString(context)));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(createErrorSnackbar(e.toString()));
      }
    },
    child: Text(LocaleData.loginTitle.getString(context), style: buttonTextStyle),
  );
}

GestureDetector buildSkipLoginButton(BuildContext context) {
  return GestureDetector(
    onTap: () async {
      if (AuthService.firebase().currentUser != null) {
        AuthService.firebase().logOut();
      }

      if (!LocalDbController().isNullUser(LocalDbController().currentUser)) {
        LocalDbController().setCurrentUser(
          user: await LocalDbController().getNullUser(),
        );
      }

      goRouterToMain(context);
    },
    child: Text(
      LocaleData.loginSkip.getString(context),
      style: TextStyle(
          fontSize: 20,
          color: usertheme.textColor.withOpacity(0.6),
          decoration: TextDecoration.underline,
          decorationColor: Colors.grey.shade400),
    ),
  );
}

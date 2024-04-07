import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:stoodee/services/auth/auth_exceptions.dart';
import 'package:stoodee/services/auth/auth_service.dart';
import 'package:stoodee/services/local_crud/local_database_service/local_database_controller.dart';
import 'dart:developer';
import 'package:stoodee/utilities/snackbar/create_snackbar.dart';
import 'package:stoodee/services/shared_prefs/shared_prefs.dart';
import 'package:stoodee/utilities/reusables/reusable_stoodee_button.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class OogaBoogaLoginTest extends StatefulWidget {
  const OogaBoogaLoginTest({
    super.key,
  });

  @override
  State<OogaBoogaLoginTest> createState() => _OogaBoogaLoginTest();
}

class _OogaBoogaLoginTest extends State<OogaBoogaLoginTest> {
  //FIXME: NIGDY NIE SĄ DISPOSOWANE MEMORY LEAK MEMORY LEAK
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool rememberBool = false;

  void initState() {
    super.initState();

    //yeah wtf does that mean, it runs gotoMain after build is finished
    if (SharedPrefs().rememberLoginData) {
      WidgetsBinding.instance.addPostFrameCallback((_) => gotoMain());
    }
  }

  void gotoMain() {
    context.go(
      '/Main',
    );
  }

  void goToEmailVerification() {
    context.go(
      '/email_verification_page',
    );
  }

  Future<void> signUpTest(String email, String password) async {
    await AuthService.firebase().createUser(email: email, password: password);
  }

  Future<void> signInTest(String email, String password) async {
    await AuthService.firebase().logIn(email: email, password: password);
  }

  @override
  Widget build(BuildContext context) {
    if (AuthService.firebase().currentUser != null) {
      //FIXME: debug log
      log(AuthService.firebase().currentUser!.email!);
      log(AuthService.firebase().currentUser!.isEmailVerified.toString());
      //FIXME: debug log ^^^
    } else {
      //FIXME: debug log
      log("user: not logged in");
    }
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: GestureDetector(
                      onTap: () {
                        context.go('/Main');
                      },
                      child: Text(
                        "skip log-in",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade400,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.grey.shade400),
                      )),
                )
              ]),
              Expanded(child: Container(), flex: 1),
              Gap(MediaQuery.of(context).size.height * 0.01),
              Image.asset(
                'lib/assets/BaseLogoSwanResized.png',
                width: 140,
                height: 140,
              ),
              Gap(25),
              SizedBox(
                height: 35,
                child: DefaultTextStyle(
                  style: const TextStyle(
                      color: primaryAppColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w900),
                  child: AnimatedTextKit(
                    displayFullTextOnTap: true,
                    repeatForever: false,
                    isRepeatingAnimation: false,
                    animatedTexts: [
                      TypewriterAnimatedText('Thanks for being with us :D',
                          speed: const Duration(milliseconds: 150),
                          curve: Curves.decelerate,
                          cursor: "|"),
                      TypewriterAnimatedText('It means a lot! ^^',
                          speed: const Duration(milliseconds: 100),
                          curve: Curves.decelerate,
                          cursor: "|"),
                      TypewriterAnimatedText('~Stoodee dev team',
                          speed: const Duration(milliseconds: 100),
                          curve: Curves.decelerate,
                          cursor: "|"),
                    ],
                  ),
                ),
              ),
              Gap(10),
              Text("Log-in ", style: TextStyle(color: Colors.grey)),
              Padding(
                padding: const EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 10, bottom: 25),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: 'E-mail',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryAppColor),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                  ),
                  controller: emailController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, left: 25, right: 25, bottom: 5),
                child: TextField(
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryAppColor),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                  ),
                  controller: passwordController,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Remember me",
                      style: TextStyle(color: Colors.grey.shade400)),
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Checkbox(
                      value: rememberBool,
                      onChanged: (newValue) async {
                        setState(() {
                          rememberBool = newValue!;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      side: MaterialStateBorderSide.resolveWith(
                        (states) =>
                            BorderSide(width: 2.0, color: primaryAppColor),
                      ),
                    );
                  }),
                  Gap(20),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StoodeeButton(
                    onPressed: () async {
                      try {
                        await signUpTest(
                          emailController.text,
                          passwordController.text,
                        );
                        await SharedPrefs()
                            .setRememberLogin(value: rememberBool);

                        await AuthService.firebase().sendEmailVerification();
                        goToEmailVerification();
                      } on EmailAlreadyInUseAuthException {
                        ScaffoldMessenger.of(context).showSnackBar(createSnackbar(
                            "Account with this e-mail addresss already exists"));
                      } on InvalidEmailAuthException {
                        ScaffoldMessenger.of(context).showSnackBar(
                            createSnackbar("Incorrect email entered"));
                      } on GenericAuthException {
                        ScaffoldMessenger.of(context).showSnackBar(
                            createSnackbar(
                                "Enter email and password to Sign-Up"));
                      } on WeakPasswordAuthException {
                        ScaffoldMessenger.of(context).showSnackBar(
                            createSnackbar(
                                "Password must contain at least 8 characters"));
                      } catch (e) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(createSnackbar(e.toString()));
                      }
                    },
                    child: Text(
                      'Sign-up',
                      style: buttonTextStyle,
                    ),
                  ),
                  StoodeeButton(
                    onPressed: () async {
                      try {
                        await signInTest(
                          emailController.text,
                          passwordController.text,
                        );

                        await SharedPrefs()
                            .setRememberLogin(value: rememberBool);

                        if (AuthService.firebase().currentUser == null) {
                          throw UserNotLoggedInAuthException();
                        }

                        //FIXME: DEBUG LOG
                        log('Logging in with: ${LocalDbController().currentUser}');

                        if (!AuthService.firebase()
                            .currentUser!
                            .isEmailVerified) {
                          goToEmailVerification();
                        } else {
                          gotoMain();
                        }
                      } on InvalidCredentialsAuthException {
                        ScaffoldMessenger.of(context).showSnackBar(
                            createSnackbar("Incorrect email or password"));
                      } on GenericAuthException {
                        ScaffoldMessenger.of(context).showSnackBar(
                            createSnackbar(
                                "Enter email and password to log-in"));
                      } catch (e) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(createSnackbar(e.toString()));
                      }
                    },
                    child: Text('Log-in', style: buttonTextStyle),
                  ),
                ],
              ),
              Expanded(child: Container(), flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}

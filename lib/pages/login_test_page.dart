import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stoodee/services/auth/auth_service.dart';
import 'dart:developer';

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

  void gotoPage1() {
    context.go('/page1',extra:"r");
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
      log(AuthService.firebase().currentUser!.email!);
      log(AuthService.firebase().currentUser!.isEmailVerified.toString());
    } else {
      log("user: not logged in");
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Logowanko uwu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              autocorrect: false,
              decoration: const InputDecoration(helperText: "Email here ^"),
              controller: emailController,
            ),
            TextField(
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(helperText: "Password here ^"),
              controller: passwordController,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await signUpTest(
                      emailController.text, passwordController.text);
                  gotoPage1();
                } catch (e) {
                  log("error occured during registration");
                  log(e.toString());
                  log(e.hashCode.toString());
                }
              },
              child: const Text('Sign-up'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await signInTest(
                      emailController.text, passwordController.text);
                  gotoPage1();
                } catch (e) {
                  log("error occured during login");
                  log(e.toString());
                  log(e.hashCode.toString());
                }
              },
              child: const Text('Log-in'),
            ),
          ],
        ),
      ),
    );
  }
}

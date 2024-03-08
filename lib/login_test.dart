import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OogaBoogaLoginTest extends StatefulWidget {
  const OogaBoogaLoginTest({
    super.key,
  });

  @override
  State<OogaBoogaLoginTest> createState() => _OogaBoogaLoginTest();
}

class _OogaBoogaLoginTest extends State<OogaBoogaLoginTest> {
  void gotoPage1() {
    context.go('/page1');
  }

  @override
  Widget build(BuildContext context) {
    //FIXME: nigdy nie są disposowane, MEMORY LEAK
    //FIXME: MEMORY LEAK
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
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
              decoration: const InputDecoration(helperText: "Email here ^"),
              controller: emailController,
            ),
            TextField(
              decoration: const InputDecoration(helperText: "Password here ^"),
              controller: passwordController,
            ),
            ElevatedButton(
              onPressed: () {
                gotoPage1();
              },
              child: const Text('Sign-up'),
            ),
            ElevatedButton(
              onPressed: () {
                gotoPage1();
              },
              child: const Text('Log-in'),
            ),
          ],
        ),
      ),
    );
  }
}

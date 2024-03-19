import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _goToLoginTest() {
    context.go('/login_test');
  }

  void _goToMainPage() {
    context.go('/Main');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: _goToLoginTest,
              child: const Text("go to Login Page"),
            ),
            TextButton(
              onPressed: _goToMainPage,
              child: const Text("Skip log-in"),
            )
          ],
        ),
      ),
    );
  }
}

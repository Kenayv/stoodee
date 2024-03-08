import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Page1 extends StatefulWidget {
  const Page1({
    super.key,
  });

  @override
  State<Page1> createState() => _Page1();
}

class _Page1 extends State<Page1> {
  void _incrementCounter() {
    setState(() {});
  }

  void gotomain() {
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('page1'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: gotomain, child: const Text('aaa')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

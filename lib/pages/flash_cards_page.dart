import 'package:flutter/material.dart';

class FlashCardsPage extends StatefulWidget {
  const FlashCardsPage({
    super.key,
  });

  @override
  State<FlashCardsPage> createState() => _FlashCardsPage();
}

class _FlashCardsPage extends State<FlashCardsPage> {
  int pageIndex = 1;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("FlashCards"),
              ],
            )
          ],
        ),
      ),
    );
  }
}

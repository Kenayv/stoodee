import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stoodee/services/auth/auth_service.dart';

class FlashCardsPage extends StatefulWidget {
  const FlashCardsPage({
    super.key,
  });

  @override
  State<FlashCardsPage> createState() => _FlashCardsPage();
}

class _FlashCardsPage extends State<FlashCardsPage> {
  int pageIndex = 1;
  void gotomain() {
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  if (AuthService.firebase().currentUser != null) {
                    AuthService.firebase().logOut();
                  }
                  gotomain();
                },
                child: const Text('Log out')),
            const Row(
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

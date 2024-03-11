import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stoodee/services/auth/auth_service.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({
    super.key,
  });

  @override
  State<AchievementsPage> createState() => _AchievementsPage();
}

class _AchievementsPage extends State<AchievementsPage> {
  int pageIndex=4;
  void gotomain() {
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Achievements Page'),
      ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      context.go("/Main", extra: pageIndex);
                    },
                    child: const Text("Main")),
                ElevatedButton(
                    onPressed: () {
                      context.go("/Account", extra: pageIndex);
                    },
                    child: const Text("Account")),
              ],
            )
          ],
        ),
      ),
    );
  }
}

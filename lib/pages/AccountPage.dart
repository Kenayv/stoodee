import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stoodee/services/auth/auth_service.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({
    super.key,
  });

  @override
  State<AccountPage> createState() => _AccountPage();
}

class _AccountPage extends State<AccountPage> {
  int pageIndex=5;
  void gotomain() {
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('AccountPage'),
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
                      context.go("/Achievements", extra: pageIndex);
                    },
                    child: const Text("Achievements")),
              ],
            )
          ],
        ),
      ),
    );
  }
}

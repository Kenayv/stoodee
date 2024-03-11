import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stoodee/services/auth/auth_service.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {

  int pageIndex=3;

  void gotomain() {
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Main Page'),
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



            //TODO: debug widget ONLY, will be replaced by navbar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        context.go("/Todo", extra: pageIndex);
                      },
                      child: const Text("Todo")),
                  ElevatedButton(
                      onPressed: () {
                        context.go("/FlashCards", extra: pageIndex);
                      },
                      child: const Text("FlashCards")),

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

                  ElevatedButton(
                      onPressed: () {
                        context.go("/Account", extra: pageIndex);
                      },
                      child: const Text("Account")),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

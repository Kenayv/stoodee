import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stoodee/services/router/route_functions.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:stoodee/utilities/reusables/custom_appbar.dart';

class PageScaffold extends StatefulWidget {
  const PageScaffold({required this.child, super.key});

  final Widget child;

  @override
  State<PageScaffold> createState() => _PageScaffold();
}

class _PageScaffold extends State<PageScaffold> {
  int currentIndex = 2;

  String indexToTitle(int index) {
    switch (index) {
      case 1:
        return "ToDo";
      case 2:
        return "Flashcards";
      case 3:
        return "Home";
      case 4:
        return "Achievements";
      case 5:
        return "Account";
      default:
        return "?";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! > 0) {
          // Swiped right
          changeTab(currentIndex - 1);
          log("SwipeVelocity: ${details.velocity}");
        } else if (details.primaryVelocity! < 0) {
          // Swiped left
          changeTab(currentIndex + 1);
          log("SwipeVelocity: ${details.velocity}");
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: indexToTitle(currentIndex + 1),
          titleWidget: Text(indexToTitle(currentIndex + 1),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          leading: const Text(''),
        ),
        body: widget.child,
        bottomNavigationBar: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            //highlightColor: Colors.transparent,

          ),
          child: SafeArea(
            child: Container(
              height: 70, //TODO: In Future remove the height
              padding:
                  const EdgeInsets.only(top: 4, bottom: 4, left: 18, right: 18),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: primaryAppColor,
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: BottomNavigationBar(
                elevation: 0,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                selectedFontSize: 0,
                unselectedIconTheme: IconThemeData(
                    color: CupertinoColors.inactiveGray.withOpacity(0.85),
                    size: 22),
                selectedIconTheme: const IconThemeData(size: 30),
                onTap: changeTab,
                backgroundColor: const Color(0xff230734),
                currentIndex: currentIndex,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.list),
                      label: 'ToDo',
                      backgroundColor: Colors.transparent),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.add_circle),
                      label: 'Flashcards',
                      backgroundColor: Colors.transparent),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                      backgroundColor: Colors.transparent),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.add_chart),
                      label: 'Achievements',
                      backgroundColor: Colors.transparent),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.account_box_rounded),
                      label: 'Account',
                      backgroundColor: Colors.transparent),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void changeTab(int index) {
    if (index >= 0 && index < 5) {
      switch (index) {
        case 0:
          goRouterToToDo(context,currentIndex + 1);
          break;
        case 1:
          goRouterToFlashCards(context,currentIndex+1);
          break;

        case 2:
          goRouterToMain(context,currentIndex + 1);
          break;

        case 3:
          goRouterToAchievements(context,currentIndex + 1);
          break;

        case 4:
          goRouterToAccount(context,currentIndex + 1);
          break;

        default:
          context.go('/');
          break;
      }
      setState(() {
        currentIndex = index;
      });
    }
  }
}

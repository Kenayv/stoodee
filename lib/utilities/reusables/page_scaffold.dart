import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:stoodee/localization/locales.dart';
import 'package:stoodee/services/router/route_functions.dart';
import 'package:stoodee/stoodee_icons_icons.dart';
import 'package:stoodee/utilities/reusables/custom_appbar.dart';
import 'package:stoodee/utilities/theme/theme.dart';

GlobalKey navigatorKey = GlobalKey(debugLabel: 'btm_app_bar');

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
        return LocaleData.page1Title.getString(context);
      case 2:
        return LocaleData.page2Title.getString(context);
      case 3:
        return LocaleData.page3Title.getString(context);
      case 4:
        return LocaleData.page4Title.getString(context);
      case 5:
        return LocaleData.page5Title.getString(context);
      default:
        return "?";
    }
  }

  bool isGestureHandled = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (!isGestureHandled) {
          if (details.delta.dx > 0) {
            // Swiped right
            changeTab(currentIndex - 1);
            log("SwipeVelocity: ${details.delta.dx}");
          } else if (details.delta.dx < 0) {
            // Swiped left
            changeTab(currentIndex + 1);
            log("SwipeVelocity: ${details.delta.dx}");
          }
          isGestureHandled = true; // Mark the gesture as handled
        }
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        // Reset the flag when the drag ends
        isGestureHandled = false;
      },
      child: Scaffold(
        backgroundColor: usertheme.backgroundColor,
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
              decoration: BoxDecoration(
                color: usertheme.primaryAppColor,
                borderRadius: const BorderRadius.all(Radius.circular(24)),
              ),
              child: BottomNavigationBar(
                key: navigatorKey,
                elevation: 0,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                selectedFontSize: 0,
                unselectedIconTheme: IconThemeData(
                    color: CupertinoColors.inactiveGray.withOpacity(0.75),
                    size: 18),
                selectedIconTheme: const IconThemeData(size: 26),
                onTap: changeTab,
                backgroundColor: const Color(0xff230734),
                currentIndex: currentIndex,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(StoodeeIcons.tasks),
                      label: 'ToDo',
                      backgroundColor: Colors.transparent),
                  BottomNavigationBarItem(
                      icon: Icon(StoodeeIcons.flashcards),
                      label: 'Flashcards',
                      backgroundColor: Colors.transparent),
                  BottomNavigationBarItem(
                      icon: Icon(StoodeeIcons.home),
                      label: 'Home',
                      backgroundColor: Colors.transparent),
                  BottomNavigationBarItem(
                      icon: Icon(StoodeeIcons.trophy),
                      label: 'Achievements',
                      backgroundColor: Colors.transparent),
                  BottomNavigationBarItem(
                      icon: Icon(StoodeeIcons.user),
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
          goRouterToToDo(context, currentIndex + 1);
          break;
        case 1:
          goRouterToFlashCards(context, currentIndex + 1);
          break;

        case 2:
          goRouterToMain(context, currentIndex + 1);
          break;

        case 3:
          goRouterToAchievements(context, currentIndex + 1);
          break;

        case 4:
          goRouterToAccount(context, currentIndex + 1);
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

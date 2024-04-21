import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:stoodee/pages/flash_cards_page.dart';
import 'package:stoodee/pages/intro_screen_page.dart';
import 'package:stoodee/pages/starting_page.dart';
import 'package:stoodee/pages/to_do_page.dart';
import 'package:stoodee/pages/email_verification_page.dart';
import 'package:stoodee/pages/login_page.dart';
import 'package:stoodee/pages/main_page.dart';
import 'package:stoodee/pages/achievements_page.dart';
import 'package:stoodee/pages/account_page.dart';
import 'package:stoodee/pages/page_scaffold.dart';
import 'package:stoodee/pages/flash_cards_reader.dart';
import 'package:stoodee/utilities/page_utilities/achievement_widgets.dart';
import 'package:stoodee/services/local_crud/local_database_service/consts.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/utilities/containers.dart';
import 'package:stoodee/utilities/dialogs/achievement_dialog.dart';
import 'package:stoodee/utilities/dialogs/side_sheet_page.dart';
import '../../utilities/dialogs/deleting_set_dialog.dart';
import '../../utilities/dialogs/dialog_page.dart';
import '../../utilities/dialogs/not_for_production_use/custom_dialog.dart';

String resolveSwipeDirection(Object from, int where) {
  String sTemp = from.toString();

  if (from == "l") {
    return "fromLeft";
  } else if (from == "r") {
    return "fromRight";
  }

  try {
    int fromIndex = int.parse(sTemp);
    if (fromIndex > where) {
      return "toRight";
    } else if (fromIndex < where) {
      return "toLeft";
    }
  } on FormatException {
    return 'notResolved';
  }

  return "notResolved";
}

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: "root");
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: "shell");

final GoRouter goRouterService = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: <RouteBase>[
    ShellRoute(
        navigatorKey: _shellNavigatorKey,
        //builder: (context, state, child) => PageScaffold(child: child),

        pageBuilder: (context, state, child) {
          return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 200),
            key: state.pageKey,
            child: PageScaffold(child: child),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0, -1.0);
              const end = Offset.zero;
              const curve = Curves.easeOutQuint;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                  position: animation.drive(tween), child: child);
            },
          );
        },
        routes: [
          GoRoute(
            path: '/ToDo',
            parentNavigatorKey: _shellNavigatorKey,
            pageBuilder: (context, state) {
              final fromIndex = state.extra ?? "3";
              int whereIndex = 1;

              String direction = resolveSwipeDirection(fromIndex, whereIndex);

              return CustomTransitionPage(
                transitionDuration: const Duration(milliseconds: 400),
                key: state.pageKey,
                child: const ToDoPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(1.0, 0.0);

                  if (direction == "toLeft") begin = const Offset(1.0, 0.0);
                  if (direction == "toRight") begin = const Offset(-1.0, 0.0);

                  const end = Offset.zero;
                  const curve = Curves.easeOutQuint;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                      position: animation.drive(tween), child: child);
                },
              );
            },
          ),

          //FLASHCARDSPAGE
          GoRoute(
              path: '/Flashcards',
              parentNavigatorKey: _shellNavigatorKey,
              pageBuilder: (context, state) {
                final fromIndex = state.extra ?? "3";
                int whereIndex = 2;

                String direction = resolveSwipeDirection(fromIndex, whereIndex);

                return CustomTransitionPage(
                  transitionDuration: const Duration(milliseconds: 400),
                  key: state.pageKey,
                  child: const FlashcardsPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    var begin = const Offset(1.0, 0.0);

                    if (direction == "toLeft") begin = const Offset(1.0, 0.0);
                    if (direction == "toRight") begin = const Offset(-1.0, 0.0);

                    const end = Offset.zero;
                    const curve = Curves.easeOutQuint;
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));

                    return SlideTransition(
                        position: animation.drive(tween), child: child);
                  },
                );
              },
              routes: [
                GoRoute(
                  path: "dialog",

                  //TODO: TUTAJ SOBIE POZMIENIAJ JAK CHCESZ Z JAKIMIS FUTURE VOIDAMI CZY COS NIE WIEM
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    var extras = state.extra as SetContainer;
                    String name = extras.name;
                    DatabaseFlashcardSet fcset = extras.getSet();

                    return SideSheetPage(
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween(
                            begin: const Offset(0, 1),
                            end: const Offset(0, 0),
                          ).animate(
                            animation,
                          ),
                          child: child,
                        );
                      },
                      child: DeleteSetDialog(
                        fcSet: fcset,
                        fcset: fcset,
                      ),
                      barrierColor: null,
                    );
                  },
                ),
              ]),

          //Main
          GoRoute(
            path: '/Main',
            parentNavigatorKey: _shellNavigatorKey,
            pageBuilder: (context, state) {
              final fromIndex = state.extra ?? "3";
              int whereIndex = 3;

              String direction = resolveSwipeDirection(fromIndex, whereIndex);

              return CustomTransitionPage(
                transitionDuration: const Duration(milliseconds: 400),
                key: state.pageKey,
                child: const MainPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(1.0, 0.0);

                  if (direction == "toLeft") begin = const Offset(1.0, 0.0);
                  if (direction == "toRight") begin = const Offset(-1.0, 0.0);

                  const end = Offset.zero;
                  const curve = Curves.easeOutQuint;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                      position: animation.drive(tween), child: child);
                },
              );
            },
          ),

          //Achievements
          GoRoute(
              parentNavigatorKey: _shellNavigatorKey,
              path: '/Achievements',
              pageBuilder: (context, state) {
                final fromIndex = state.extra ?? "none";

                int whereIndex = 4;

                String direction = resolveSwipeDirection(fromIndex, whereIndex);

                return CustomTransitionPage(
                  transitionDuration: const Duration(milliseconds: 400),
                  key: state.pageKey,
                  child: const AchievementsPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    var begin = const Offset(1.0, 0.0);

                    if (direction == "toLeft") begin = const Offset(1.0, 0.0);
                    if (direction == "toRight") begin = const Offset(-1.0, 0.0);

                    const end = Offset.zero;
                    const curve = Curves.easeOutQuint;
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));

                    return SlideTransition(
                        position: animation.drive(tween), child: child);
                  },
                );
              },
              routes: [
                GoRoute(
                  path: "dialog",

                  //TODO: TUTAJ SOBIE POZMIENIAJ JAK CHCESZ Z JAKIMIS FUTURE VOIDAMI CZY COS NIE WIEM
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    var extras = state.extra as AchievementTileContainer;
                    String name = extras.name;
                    String path = extras.path;
                    String desc = extras.desc;
                    return SideSheetPage(
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween(
                            begin: const Offset(0, 1),
                            end: const Offset(0, 0),
                          ).animate(
                            animation,
                          ),
                          child: child,
                        );
                      },
                      child:
                          AchievementDialog(name: name, path: path, desc: desc),
                    );
                  },
                ),
              ]),

          //Account
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: '/Account',
            pageBuilder: (context, state) {
              final fromIndex = state.extra ?? "none";

              //FIXME
              //FIXME
              //FIXME

              debug___Print___info(
                sharedprefs: true,
                authService: true,
                localDbUser: true,
              );

              //FIXME
              //FIXME
              //FIXME

              int whereIndex = 5;

              String direction = resolveSwipeDirection(fromIndex, whereIndex);

              return CustomTransitionPage(
                transitionDuration: const Duration(milliseconds: 400),
                key: state.pageKey,
                child: const AccountPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(1.0, 0.0);

                  if (direction == "toLeft") begin = const Offset(1.0, 0.0);
                  if (direction == "toRight") begin = const Offset(-1.0, 0.0);

                  const end = Offset.zero;
                  const curve = Curves.easeOutQuint;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                      position: animation.drive(tween), child: child);
                },
              );
            },
          ),
        ]),
    GoRoute(
        path: '/flash_cards_reader',
        pageBuilder: (context, state) {
          SetContainer container = state.extra as SetContainer;
          return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 400),
            key: state.pageKey,
            child: FlashCardsReader(
              fcSet: container.getSet(),
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0, 1.0);
              const end = Offset.zero;
              const curve = Curves.easeOutQuint;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                  position: animation.drive(tween), child: child);
            },
          );
        },
        routes: [
          GoRoute(
            path: "dialog",
            pageBuilder: (BuildContext context, GoRouterState state) {
              return SideSheetPage(
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween(
                      begin: const Offset(0, 1),
                      end: const Offset(0, 0),
                    ).animate(
                      animation,
                    ),
                    child: child,
                  );
                },
                child: CustomDialog(
                  title: '',
                  content: '',
                ),
                barrierColor: null,
              );
            },
          ),
        ]),
    GoRoute(
        path: '/login',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 400),
            key: state.pageKey,
            child: const LoginPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeOutQuint;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                  position: animation.drive(tween), child: child);
            },
          );
        },
        routes: [
          GoRoute(
            path: "dialog",

            //TODO: TUTAJ SOBIE POZMIENIAJ JAK CHCESZ Z JAKIMIS FUTURE VOIDAMI CZY COS NIE WIEM
            pageBuilder: (BuildContext context, GoRouterState state) {
              return DialogPage(
                builder: (_) => const CustomDialog(
                  title: 'title',
                  content: 'content',
                ),
              );
            },
          ),
        ]),
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 400),
          key: state.pageKey,
          child: const StartingPage(title: "lol"),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeOutQuint;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
                position: animation.drive(tween), child: child);
          },
        );
      },
    ),
    GoRoute(
        path: '/intro',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 700),
            key: state.pageKey,
            child: const IntroductionScreens(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 5.0);
              const end = Offset.zero;
              const curve = Curves.easeOutQuint;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                  position: animation.drive(tween), child: child);
            },
          );
        },
        routes: const []),
    GoRoute(
      path: '/email_verification_page',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 400),
          key: state.pageKey,
          child: const EmailVerificationPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeOutQuint;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
                position: animation.drive(tween), child: child);
          },
        );
      },
    ),
  ],
);

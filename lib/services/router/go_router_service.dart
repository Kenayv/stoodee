import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:stoodee/pages/home_page.dart';
import 'package:stoodee/pages/login_test_page.dart';
import 'package:stoodee/pages/page1.dart';

import '../../pages/page2.dart';
import '../../pages/page3.dart';
import '../../utilities/dialogs/dialog_page.dart';
import '../../utilities/dialogs/custom_dialog.dart';

final GoRouter goRouterService = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 200),
          key: state.pageKey,
          child: const HomePage(title: 'homepage'),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity:
                  CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/page1',
      pageBuilder: (context, state) {
        final direction=state.extra?? "none" ;
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 400),
          key: state.pageKey,
          child: const Page1(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(1.0, 0.0);

            if(direction=="l") begin=const Offset(1.0,0.0);
            if(direction=="r") begin=const Offset(-1.0,0.0);


            const end = Offset.zero;
            const curve = Curves.easeOutQuint;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
                position: animation.drive(tween), child: child);
          },
        );
      },

      routes:[  //test dialog
        GoRoute(
          path:'dialog',
          pageBuilder: (BuildContext context, GoRouterState state) {

            return DialogPage(builder: (_) => CustomDialog(title: "lol", content: "content"),

            );
          },
        )
      ]

    ),

    GoRoute(
        path: '/page2',
        pageBuilder: (context, state) {
          final direction=state.extra?? "none" ;
          return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 400),
            key: state.pageKey,
            child: const Page2(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var begin = const Offset(1.0, 0.0);

              if(direction=="l") begin=const Offset(1.0,0.0);
              if(direction=="r") begin=const Offset(-1.0,0.0);


              const end = Offset.zero;
              const curve = Curves.easeOutQuint;
              var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                  position: animation.drive(tween), child: child);
            },
          );
        },

        routes:[  //test dialog
          GoRoute(
            path:'dialog',
            pageBuilder: (BuildContext context, GoRouterState state) {

              return DialogPage(builder: (_) => CustomDialog(title: "lol", content: "content"),

              );
            },
          )
        ]

    ),

    GoRoute(
        path: '/page3',
        pageBuilder: (context, state) {
          final direction=state.extra?? "none" ;
          return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 400),
            key: state.pageKey,
            child: const Page3(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var begin = const Offset(1.0, 0.0);

              if(direction=="l") begin=const Offset(1.0,0.0);
              if(direction=="r") begin=const Offset(-1.0,0.0);


              const end = Offset.zero;
              const curve = Curves.easeOutQuint;
              var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                  position: animation.drive(tween), child: child);
            },
          );
        },

        routes:[  //test dialog
          GoRoute(
            path:'dialog',
            pageBuilder: (BuildContext context, GoRouterState state) {

              return DialogPage(builder: (_) => CustomDialog(title: "lol", content: "content"),

              );
            },
          )
        ]

    ),

    GoRoute(
      path: '/login_test',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 400),
          key: state.pageKey,
          child: const OogaBoogaLoginTest(),
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

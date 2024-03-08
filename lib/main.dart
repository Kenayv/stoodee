import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'page1.dart';


void main() {
  runApp(const MyApp());
}



final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      pageBuilder: (context, state){
        return CustomTransitionPage(
          transitionDuration: Duration(milliseconds: 200),
          key: state.pageKey,
          child: MyHomePage(title:'homepage'),
          transitionsBuilder: (context,animation,secondaryAnimation,child){

            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/page1',
      pageBuilder: (context, state){
        return CustomTransitionPage(
          transitionDuration: Duration(milliseconds: 400),
          key: state.pageKey,
          child: Page1(),
          transitionsBuilder: (context,animation,secondaryAnimation,child){
            const begin=Offset(1.0,0.0);
            const end=Offset.zero;
            const curve=Curves.easeOutQuint;
            var tween = Tween(begin: begin, end:end).chain(CurveTween(curve:curve));


            return SlideTransition(
              position: animation.drive(tween),
              child: child
            );
          },
        );
      },

    ),




  ],
);




class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  void gotopage1(){
    context.go('/page1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '',
            ),
            Text(
              '',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: gotopage1,
        tooltip: 'Increment',
        child: const Text('gotopage1'),
      ),
    );
  }
}

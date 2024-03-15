import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class PageScaffold extends StatefulWidget{

  PageScaffold({
    required this.child,
    super.key
});

  final Widget child;

  @override
  State<PageScaffold> createState() => _PageScaffold();

}


class _PageScaffold extends State<PageScaffold>{

  int currentIndex=0;

  Color primaryAppColor = Color.fromRGBO(109, 0, 239, 1);


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: primaryAppColor,
        title: Text("lol",style: TextStyle(color: Colors.white)),
      ),
      body: widget.child,



      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: SafeArea(
          child: Container(
            height: 70, //TODO: In Future remove the height
            padding: const EdgeInsets.symmetric(vertical:8,horizontal: 4),
            margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
            decoration: BoxDecoration(
              color: primaryAppColor,
              borderRadius: const BorderRadius.all(Radius.circular(24)),

            ),
            child: BottomNavigationBar(
              elevation: 0,
              selectedLabelStyle: TextStyle(fontSize: 12),

              onTap: changeTab,
              backgroundColor: const Color(0xff230734),
              currentIndex: currentIndex,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.list,size: 24), label: 'ToDo',backgroundColor: Colors.transparent),
                BottomNavigationBarItem(icon: Icon(Icons.add_circle,size: 24), label: 'FlashCards',backgroundColor: Colors.transparent),
                BottomNavigationBarItem(icon: Icon(Icons.home,size: 24), label: 'Home',backgroundColor: Colors.transparent),
                BottomNavigationBarItem(icon: Icon(Icons.add_chart,size: 24), label: 'Achievements',backgroundColor: Colors.transparent),
                BottomNavigationBarItem(icon: Icon(Icons.account_box_rounded,size: 24), label: 'Account',backgroundColor: Colors.transparent),
              ],
            ),
          ),
        ),
      ),
    );
  }



  void changeTab(int index) {
    switch(index){
      case 0:
        context.go('/ToDo',extra: currentIndex+1);
        break;
      case 1:
        context.go('/FlashCards',extra: currentIndex+1);
        break;

      case 2:
        context.go('/Main',extra: currentIndex+1);
        break;

      case 3:
        context.go('/Achievements',extra: currentIndex+1);
        break;


      case 4:
        context.go('/Account',extra: currentIndex+1);
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

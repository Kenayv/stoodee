import 'package:flutter/material.dart';

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({
    super.key,
  });

  @override
  State<FlashcardsPage> createState() => _FlashcardsPage();
}

ListTile _flashcardSetItem({
  required BuildContext context,
  required List<String> fcSet,
  required String name,
}) {
  return ListTile(
    title: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: Colors.purple[300],
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.topCenter,
                height: 35,
                child: const Row(
                  children: [
                    //TODO: MAKE THEM DO SOMETHING WITH BUTTONS, AND SPACE THEM CORRECTLY
                    Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.white,
                    ),
                    Icon(Icons.star, size: 20, color: Colors.white),
                    Icon(Icons.lock, size: 20, color: Colors.white),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                height: 40,
                child: Text(
                  name,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                height: 100,
                child: Text(
                  'Pair count: ${fcSet.length}',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

List<Widget> flashcardSetListView({required BuildContext context}) {
  //FIXME: debug debug
  List<String> emptySet = [];
  final flashcardSets = [
    ["xd", "lol", "debug"],
    ["yeet", "debug", "set"],
    emptySet,
    ["hihi", "haha"],
    ["woooo"],
    ['another', 'set', 'test'],
    ['another', 'set', 'test'],
    ['another', 'set', 'test'],
    ['another', 'set', 'test'],
    ['another', 'set', 'test'],
    ['another', 'set', 'test'],
    ['another', 'set', 'test'],
  ];

  List<Widget> flashcardList = [];

  for (int i = 0; i < flashcardSets.length; i++) {
    flashcardList.add(_flashcardSetItem(
      context: context,
      fcSet: flashcardSets[i],
      name: "debug set $i",
    ));
  }

  return flashcardList;
}

class _FlashcardsPage extends State<FlashcardsPage> {
  int pageIndex = 1; //FIXME: NOT USED????

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/

    return Scaffold(
      body: Center(
        child: GridView.count(
          primary: false,
          childAspectRatio: (1 / 1.3),
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          crossAxisCount: 2,
          children: flashcardSetListView(context: context),
        ),

        //flashcardSetListView(context: context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print("DEBUG DEBUG add flash card Debug Debug");
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

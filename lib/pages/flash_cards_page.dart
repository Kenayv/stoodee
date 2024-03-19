import 'package:flutter/material.dart';

class FlashCardsPage extends StatefulWidget {
  const FlashCardsPage({
    super.key,
  });

  @override
  State<FlashCardsPage> createState() => _FlashCardsPage();
}

ListTile _flashCardSetItem({
  required BuildContext context,
  required List<String> fcSet,
  required String name,
}) {
  return ListTile(
    title: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 92,
        decoration: BoxDecoration(
          color: Colors.purple[300],
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Card count: ${fcSet.length}',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

ListView flashCardSetListView({required BuildContext context}) {
  //FIXME: debug debug
  List<String> emptySet = [];
  final flashCardSets = [
    ["xd", "lol", "debug"],
    ["yeet", "debug", "set"],
    emptySet,
    ["hihi", "haha"],
    ["woooo"],
    ['another', 'set', 'test']
  ];

  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: flashCardSets.length,
    itemBuilder: (context, index) {
      return _flashCardSetItem(
        context: context,
        fcSet: flashCardSets[index],
        name: "debug set $index",
      );
    },
  );
}

class _FlashCardsPage extends State<FlashCardsPage> {
  int pageIndex = 1; //FIXME: NOT USED????

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: flashCardSetListView(context: context),
        ),
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

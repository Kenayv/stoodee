import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:stoodee/utilities/containers.dart';

import 'package:stoodee/utilities/globals.dart';
import 'package:stoodee/utilities/snackbar/create_snackbar.dart';

void tap(
    BuildContext context,
    SetContainer container,
    ) {
  context.go('/flash_cards_reader', extra: container);
}

class FlashCardSetWidget_intro extends StatefulWidget {
  const FlashCardSetWidget_intro({
    super.key,
    required this.context,
    required this.fcSetlength,
    required this.name,
  });

  @override
  State<FlashCardSetWidget_intro> createState() => _FlashCardSetWidgetState();

  final BuildContext context;
  final int fcSetlength;
  final String name;
}

class _FlashCardSetWidgetState extends State<FlashCardSetWidget_intro> {


  List<BoxShadow> resolveWidgetShadows() {
    List<BoxShadow> l = [];

    if (widget.fcSetlength > 2) {
      l.add(const BoxShadow(
        color: Color.fromRGBO(75, 0, 178, 1.0),
        spreadRadius: 1,
        offset: Offset(9.0, 3.0),
      ));
    }

    if (widget.fcSetlength > 1) {
      l.add(const BoxShadow(
        color: Color.fromRGBO(92, 0, 206, 1.0),
        spreadRadius: 1,
        offset: Offset(5.0, 2),
      ));
    }

    if (widget.fcSetlength > 0) {
      l.add(const BoxShadow(
        color: primaryAppColor,
        spreadRadius: 1,
        offset: Offset(2.0, 1),
      ));
    }

    return l;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            decoration: BoxDecoration(
              color: analogusColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: resolveWidgetShadows(),
            ),
            child: Center(
              child: Column(
                children: [
                  const Gap(10),
                  Container(
                    alignment: Alignment.topCenter,
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 8,
                          child: TextButton(
                              onPressed: ()  {
                                ScaffoldMessenger.of(context).showSnackBar(createNeutralSnackbar("We would show what it does, but its just a preview. \nFor more, finish this preview :D"));
                              },
                              child: const Icon(
                                Icons.add,
                                size: 20,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      widget.name,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      height: 100,
                      child: Text(
                        'Total pairs: ${widget.fcSetlength}',
                        style:
                        const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onTap: () {
          "tapped";
        },
        splashColor: Colors.transparent,
    );
  }
}

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_flashcard_set.dart';
import 'package:stoodee/services/router/route_functions.dart';
import 'package:stoodee/utilities/reusables/reusable_card.dart';
import 'package:stoodee/utilities/reusables/reusable_stoodee_button.dart';

import '../globals.dart';
import 'custom_appbar.dart';

class EmptyReaderScaffold extends StatelessWidget{
   EmptyReaderScaffold({super.key,required this.fcset});


  void nothing(){

  }


  DatabaseFlashcardSet fcset;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: Text(""),
        titleWidget: Text(
          fcset.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: StoodeeButton(
                      onPressed: (){
                        goRouterToMain(context);
                      },
                      child: const Icon(Icons.arrow_back,
                          color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Text("empty"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius:
                    const BorderRadius.all(Radius.circular(10)),
                    child: LinearPercentIndicator(
                      backgroundColor:
                      primaryAppColor.withOpacity(0.08),
                      percent: 0,
                      linearGradient: const LinearGradient(
                        colors: [
                          primaryAppColor,
                          secondaryAppColor
                        ],
                      ),
                      animation: true,
                      lineHeight: 20,
                      restartAnimation: false,
                      animationDuration: 150,
                      curve: Curves.easeOut,
                      barRadius: const Radius.circular(10),
                      animateFromLastPercent: true,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: FlipCard(
                    speed: 250,
                    onFlip: () {

                    },
                    side: CardSide.FRONT,
                    direction: FlipDirection.HORIZONTAL,
                    front: ReusableCard(
                      text: "",
                    ),
                    back: ReusableCard(
                      text: "",
                    ),
                  ),
                ),

                const Expanded(child: Text("")),


              ],
            ),
          ),

        ],
      ),
    );
  }






}
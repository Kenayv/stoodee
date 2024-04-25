import 'dart:math';
import 'dart:developer' as dart_dev;

import 'package:stoodee/utilities/globals.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

double truncateToDecimalPlaces(num value, int fractionalDigits) =>
    (value * pow(10, fractionalDigits)).truncate() / pow(10, fractionalDigits);

bool isNotMaxedOut(int value, int max) {
  if (value / max != 1) {
    return true;
  } else {
    return false;
  }
}

double couldBeZero(int max){

  if(max==0){
    return 1.0;
  }
  else return max.toDouble();


}

double determineInterval(int max){

  if(max<10){
    return 1;
  }

  else if(max<80){
    return 5;
  }
  else if(max>80){
    return 10;
  }

  return 1;

}




Column stoodeeLinearGauge({
  required int value,
  required int max,
  required Icon titleIcon,
  required double containerHeight,
}) {

  double max_double=couldBeZero(max);

  //math
  double degree = 180 * (value / max_double);
  double percent = value / max_double;
  double displaypercent = truncateToDecimalPlaces(percent * 100, 2);
  //ewwwww
  dart_dev.log("degree: $degree");

  return Column(
    children: [

      Container(
        height: containerHeight * 0.3,
        child: SfLinearGauge(
          axisTrackStyle: LinearAxisTrackStyle(
            thickness: 10,
            edgeStyle: LinearEdgeStyle.bothCurve
          ),

          maximum: couldBeZero(max),
          interval: determineInterval(max),
          showTicks: false,

          barPointers: [
            LinearBarPointer(value: value.toDouble(),color: primaryAppColor,edgeStyle: LinearEdgeStyle.bothCurve,thickness: 10),
          ],
           ),
      ),
    ],
  );
}

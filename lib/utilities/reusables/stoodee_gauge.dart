import 'dart:math';
import 'dart:developer' as dart_dev;

import 'package:stoodee/utilities/globals.dart';
import 'package:stoodee/utilities/theme/theme.dart';
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

Column stoodeeGauge({
  required int value,
  required int max,
  required Icon titleIcon,
  required double containerHeight,
}) {
  //math
  double degree = 180 * (value / max);
  double percent = value / max;
  double displaypercent = truncateToDecimalPlaces(percent * 100, 2);
  //ewwwww
  dart_dev.log("degree: $degree");

  return Column(
    children: [
      SizedBox(
        height: containerHeight * 0.3,
        child: titleIcon,
      ),
      SizedBox(
        height: containerHeight * 0.7,
        child: SfRadialGauge(
          enableLoadingAnimation: true,
          axes: <RadialAxis>[
            RadialAxis(
                showLabels: false,
                showTicks: false,
                startAngle: 180,
                endAngle: 0,
                radiusFactor: 0.8,
                maximum: 180,
                canScaleToFit: true,
                axisLineStyle: const AxisLineStyle(
                    cornerStyle: CornerStyle.startCurve, thickness: 10),
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                      angle: 90,
                      widget: Text(
                        "$displaypercent%",
                        style:  TextStyle(fontWeight: FontWeight.bold,color: usertheme.textColor),
                      )),
                  if (value != 0)
                     GaugeAnnotation(
                      angle: 180,
                      positionFactor: 1.2,
                      widget: Text('0', style: TextStyle(color: usertheme.textColor)),
                    ),
                  GaugeAnnotation(
                    angle: 180 + degree,
                    positionFactor: 1.3,
                    widget: Text('$value',
                        style:  TextStyle(fontWeight: FontWeight.bold,color: usertheme.textColor)),
                  ),
                  if (isNotMaxedOut(value, max))
                    GaugeAnnotation(
                      angle: 0,
                      positionFactor: 1.25,
                      widget: Text('$max', style: TextStyle(color: usertheme.textColor)),
                    ),
                ],
                pointers: <GaugePointer>[
                  RangePointer(
                    value: degree,
                    width: 10,
                    pointerOffset: 0,
                    cornerStyle: CornerStyle.bothCurve,
                    color: usertheme.primaryAppColor,
                    //maybe gradient
                  ),
                ]),
          ],
        ),
      ),
    ],
  );
}

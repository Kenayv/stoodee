import 'package:stoodee/utilities/globals.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:stoodee/stoodee_icons_icons.dart';



Column StoodeeGauge(int value, int max,Icon titleIcon){

  double degree=180*(value/max);

  return Column(
    children: [
      Container(
        height:70,
        child: titleIcon,
      ),


      Container(
        height:150,
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
                axisLineStyle: const AxisLineStyle(
                    cornerStyle: CornerStyle.startCurve, thickness: 10),

                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                      angle: 90,
                      widget: Text("$value/$max",style: TextStyle(fontWeight: FontWeight.bold),)

                  ),
                  GaugeAnnotation(
                    angle: 180,
                    positionFactor: 1.2,
                    widget:
                    Text('0', style: TextStyle()),
                  ),
                  GaugeAnnotation(
                    angle: 180+degree,
                    positionFactor: 1.3,
                    widget:
                    Text('$value', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  GaugeAnnotation(
                    angle: 0,
                    positionFactor: 1.25,
                    widget: Text('$max',
                        style: TextStyle()),
                  ),
                ],
                pointers: <GaugePointer>[
                  RangePointer(
                    value: degree,
                    width: 10,
                    pointerOffset: 0,
                    cornerStyle: CornerStyle.bothCurve,
                    color: primaryAppColor,

                  ),

                ]),
          ],
        ),
      ),
    ],
  );




}
import 'package:flutter/material.dart';
import 'package:stoodee/utilities/globals.dart';



class StoodeeButton extends StatelessWidget{

  final Widget child;
  final VoidCallback onPressed;
  Size size;

  StoodeeButton({super.key, required this.child,required this.onPressed,this.size=const Size(10,10)});


  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(


      ),

      child: ElevatedButton(onPressed: onPressed, style: ElevatedButton.styleFrom(
        shadowColor: primaryAppColor,
        backgroundColor: analogusColor,




      ) ,


          child: FittedBox(
              fit:BoxFit.fitWidth,
              child: child
          )

      ),
    );


  }

}
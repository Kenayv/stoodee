import 'package:flutter/material.dart';
import 'package:stoodee/utilities/globals.dart';



class StoodeeButton extends StatelessWidget{

  final Widget child;
  final VoidCallback onPressed;
  Size size;

  StoodeeButton({super.key, required this.child,required this.onPressed,this.size=const Size(10,10)});

  Color color1=primaryAppColor;
  Color color2=analogusColor;


  Widget resolveWidgetSize(){
    if(size==Size(10,10)){
      return  Padding(

        padding: const EdgeInsets.all(12.0),
        child: FittedBox(
            fit:BoxFit.fitWidth,
            child: child
        ),
      );
    }
    else{
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          alignment: Alignment.center,
          width:size.width,
          height:size.height,


          child:child,
        ),
      );
    }

  }



  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: Container(

          decoration:  BoxDecoration(
              gradient: LinearGradient(colors: [color1,color2],begin:Alignment.topCenter,end:Alignment.bottomCenter,stops: [0.85,1]),
              border: Border(
                  bottom: BorderSide(
                    color: color2,
                    width: 2.5,
                  ),

              )


          ),
          child: resolveWidgetSize(),
        ),
      ),
    );


  }

}
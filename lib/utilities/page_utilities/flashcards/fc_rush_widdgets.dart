import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stoodee/utilities/theme/theme.dart';


void handleTimeOut(){
  print("ended lol");
}



Container buildTimer(){

  Container container=Container(


  );





  return container;



}



Container BuildMissExes(int count){

  Container container=Container(

    child: Column(
      children: [
        Text("Misses:",style: TextStyle(color: usertheme.textColor)),
        Row(
          children: [
            for(int i=0;i<count;i++)
            Icon(Icons.close,color: Colors.red,),

            if(count==0)
              Text("none",style:TextStyle(color:usertheme.textColor))
          ],
        ),
      ],
    ),

  );





  return container;


}
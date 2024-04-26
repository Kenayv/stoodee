import 'package:flutter/material.dart';
import 'package:stoodee/utilities/globals.dart';

import '../../services/shared_prefs/shared_prefs.dart';

class StoodeeTheme {

  final Color primaryAppColor;
  final Color analogousColor;
  final Color textColor;
  final Color backgroundColor;
  final Color basicShaddow;
  final Color cardColor;





  StoodeeTheme({
    required this.primaryAppColor, required this.analogousColor, required this.textColor, required this.backgroundColor,required this.basicShaddow,required this.cardColor
  }
     );




}

final StoodeeTheme whitetheme = StoodeeTheme(
    primaryAppColor:Color.fromRGBO(109, 0, 239, 1),
    analogousColor:Color.fromRGBO(168, 71, 232, 1),
    textColor:Color.fromRGBO(0, 0, 0, 1),
    backgroundColor:Color.fromRGBO(248, 245, 250, 1.0),
  basicShaddow: Colors.grey,
    cardColor: Color.fromRGBO(236, 236, 236, 1.0)


);

/*
Light theme:
  niebieski: #6aa3f8  106, 163, 248
  czerwony: #fc6666   252, 102, 102
  fiolet: #cdb2ff     205, 178, 255
  zielony: #97e077    151, 224, 119
*/

final StoodeeTheme blacktheme = StoodeeTheme(

    primaryAppColor:Color.fromRGBO(137, 110, 255, 1.0),
    analogousColor:Color.fromRGBO(115, 110, 255, 1.0),
    textColor:Color.fromRGBO(255, 255, 255, 1),
    backgroundColor:Color.fromRGBO(31, 42, 95, 1.0),
    basicShaddow: Colors.black54,
    cardColor: Color.fromRGBO(41, 58, 126, 1.0)
);
/*
Dark theme: #1f2a5f         31, 42, 95)

  niebieski: #6aa3f8      106, 163, 248
  Fiolet: #af8ef7         175, 142, 247
  pomarańczowy: #ff8c4f   255, 140, 79
  zielony: #55d389        85, 211, 137
*/

late StoodeeTheme usertheme;




void reEvalTheme(){


  if(SharedPrefs().prefferedTheme==SharedPrefs.lightTheme){
    usertheme=whitetheme;

  }
  else{
    usertheme=blacktheme;
  }

}


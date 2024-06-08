import 'package:flutter_localization/flutter_localization.dart';

mixin LocaleData{
  static const String page1Title="ToDo";
  static const String page2Title="FlashCards";
  static const String page3Title="Home";
  static const String page4Title="Achievements";
  static const String page5Title="Account";


  static const Map<String,dynamic> EN={
    page1Title:"ToDo",
    page2Title:"FlashCards",
    page3Title:"Home",
    page4Title:"Achievements",
    page5Title:"Account",

  };

  static const Map<String,dynamic> PL={
    page1Title:"Lista zada",
    page2Title:"Fiszki",
    page3Title:"Strona główna",
    page4Title:"Osiągnięcia",
    page5Title:"Konto",

  };


}

const List<MapLocale> LOCALES=[

  MapLocale("en",LocaleData.EN),
  MapLocale("pl",LocaleData.PL)

];

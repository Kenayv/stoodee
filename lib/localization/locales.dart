import 'package:flutter_localization/flutter_localization.dart';

mixin LocaleData {
  static const String page1Title = "ToDo";
  static const String page2Title = "FlashCards";
  static const String page3Title = "Home";
  static const String page4Title = "Achievements";
  static const String page5Title = "Account";

  static const String polishLang = 'pl';
  static const String englishLang = 'en';

  static const Map<String, dynamic> en = {
    page1Title: "ToDo",
    page2Title: "FlashCards",
    page3Title: "Home",
    page4Title: "Achievements",
    page5Title: "Account",
  };

  static const Map<String, dynamic> pl = {
    page1Title: "Lista zadań",
    page2Title: "Fiszki",
    page3Title: "Strona główna",
    page4Title: "Osiągnięcia",
    page5Title: "Konto",
  };
}

const List<MapLocale> locales = [
  MapLocale(LocaleData.englishLang, LocaleData.en),
  MapLocale(LocaleData.polishLang, LocaleData.pl)
];

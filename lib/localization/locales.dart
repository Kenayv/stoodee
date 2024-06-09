import 'package:flutter_localization/flutter_localization.dart';

mixin LocaleData {

  //pagescaffold
  static const String page1Title = "ToDo";
  static const String page2Title = "FlashCards";
  static const String page3Title = "Home";
  static const String page4Title = "Achievements";
  static const String page5Title = "Account";

  //loginpage
  static const String loginSkip = "skip log-in";
  static const String loginTypewriter1="Thanks for being with us :D";
  static const String loginTypewriter2="It means a lot! ^^";
  static const String loginTypewriter3="~Stoodee team";
  static const String loginTitle="Log-in";
  static const String loginHintEmail="E-mail";
  static const String loginHintPassword="Password";
  static const String loginSignUp="Sign-up";
  static const String loginRememberMe="Remember me";

  //TODO: TRANSLATING SNACKBARS



  //mainpage
  static const String mainDidYouKnow="Did you know that...?";
  static const String mainTodaysGoal="Today's goal:";
  static const String mainCurrentDaysStreak="Current days streak:";


  //achievements

  static const String achWoodTaskName = "WoodTask";
  static const String achCopperTaskName = "CopperTask";
  static const String achSilverTaskName = "SilverTask";
  static const String achGoldTaskName = "GoldTask";
  static const String achWoodFcName = "WoodFc";
  static const String achCopperFcName = "CopperFc";
  static const String achSilverFcName = "SilverFc";
  static const String achGoldFcName = "GoldFc";
  static const String achWoodRushName = "WoodRush";
  static const String achCopperRushName = "CopperRush";
  static const String achSilverRushName = "SilverRush";
  static const String achGoldRushName = "GoldRush";
  static const String achWoodStreakName = "WoodStreak";
  static const String achCopperStreakName = "CopperStreak";
  static const String achSilverStreakName = "SilverStreak";
  static const String achGoldStreakName = "GoldStreak";


  static const String achWoodTaskDesc = "Complete 1 task";
  static const String achCopperTaskDesc = "Complete 5 tasks";
  static const String achSilverTaskDesc = "Complete 20 tasks";
  static const String achGoldTaskDesc = "Complete 50 tasks";
  static const String achWoodFcDesc = "Finish 1 flashcard";
  static const String achCopperFcDesc = "Finish 10 Flashcards";
  static const String achSilverFcDesc = "Finish 50 Flashcards";
  static const String achGoldFcDesc = "Finish 250 Flashcards";
  static const String achWoodRushDesc = "Achieve a score of 5 in Flashcards Rush";
  static const String achCopperRushDesc = "Achieve a score of 15 in Flashcards Rush";
  static const String achSilverRushDesc = "Achieve a score of 25 in Flashcards Rush";
  static const String achGoldRushDesc = "Achieve a score of 45 in Flashcards Rush";
  static const String achWoodStreakDesc = "Achieve a 1-day Streak";
  static const String achCopperStreakDesc = "Achieve a 3-day Streak";
  static const String achSilverStreakDesc = "Achieve a 7-day Streak";
  static const String achGoldStreakDesc = "Achieve a 14-day Streak";


  static const String achYouHaveUnlocked="You have unlocked %a out of 12 achievements";
  static const String achLogInToSee="Log-in to see achievements";





  static const String polishLang = 'pl';
  static const String englishLang = 'en';

  static const Map<String, dynamic> en = {
    page1Title: "ToDo",
    page2Title: "FlashCards",
    page3Title: "Home",
    page4Title: "Achievements",
    page5Title: "Account",


    loginSkip : "Skip log-in",
    loginTypewriter1:"Thanks for being with us :D",
    loginTypewriter2:"It means a lot! ^^",
    loginTypewriter3:"~Stoodee team",
    loginTitle:"Log-in",
    loginHintEmail:"E-mail",
    loginHintPassword:"Password",
    loginSignUp:"Sign-up",
    loginRememberMe:"Remember me",

   mainDidYouKnow:"Did you know that...?",
   mainTodaysGoal:"Today's goal:",
   mainCurrentDaysStreak:"Current days streak:",




    achWoodTaskName : "WoodTask",
    achCopperTaskName : "CopperTask",
    achSilverTaskName : "SilverTask",
    achGoldTaskName : "GoldTask",
    achWoodFcName : "WoodFc",
    achCopperFcName : "CopperFc",
    achSilverFcName : "SilverFc",
    achGoldFcName : "GoldFc",
    achWoodRushName : "WoodRush",
    achCopperRushName : "CopperRush",
    achSilverRushName : "SilverRush",
    achGoldRushName : "GoldRush",
    achWoodStreakName : "WoodStreak",
    achCopperStreakName : "CopperStreak",
    achSilverStreakName : "SilverStreak",
    achGoldStreakName : "GoldStreak",


    achWoodTaskDesc : "Complete 1 task",
    achCopperTaskDesc : "Complete 5 tasks",
    achSilverTaskDesc : "Complete 20 tasks",
    achGoldTaskDesc : "Complete 50 tasks",
    achWoodFcDesc : "Finish 1 flashcard",
    achCopperFcDesc : "Finish 10 Flashcards",
    achSilverFcDesc : "Finish 50 Flashcards",
    achGoldFcDesc : "Finish 250 Flashcards",
    achWoodRushDesc : "Achieve a score of 5 in Flashcards Rush",
    achCopperRushDesc : "Achieve a score of 15 in Flashcards Rush",
    achSilverRushDesc : "Achieve a score of 25 in Flashcards Rush",
    achGoldRushDesc : "Achieve a score of 45 in Flashcards Rush",
    achWoodStreakDesc : "Achieve a 1-day Streak",
    achCopperStreakDesc : "Achieve a 3-day Streak",
    achSilverStreakDesc : "Achieve a 7-day Streak",
    achGoldStreakDesc : "Achieve a 14-day Streak",

    achYouHaveUnlocked:"You have unlocked %a out of 12 achievements",
    achLogInToSee:"Log-in to see achievements",




  };

  static const Map<String, dynamic> pl = {
    page1Title: "Lista zadań",
    page2Title: "Fiszki",
    page3Title: "Strona główna",
    page4Title: "Osiągnięcia",
    page5Title: "Konto",

    loginSkip : "Pomiń logowanie",
    loginTypewriter1:"Dziękujemy za bycie z nami :D",
    loginTypewriter2:"To wiele znaczy! ^^",
    loginTypewriter3:"~Zespół Stoodee",
    loginTitle:"Zaloguj się",
    loginHintEmail:"E-mail",
    loginHintPassword:"Hasło",
    loginSignUp:"Zarejestruj się",
    loginRememberMe:"Zapamiętaj mnie",


    mainDidYouKnow:"Czy wiesz, że...?",
    mainTodaysGoal:"Dzisiejszy cel:",
    mainCurrentDaysStreak:"Aktualna seria dni:",




    achWoodTaskName: "WoodTask",
    achCopperTaskName: "CopperTask",
    achSilverTaskName: "SilverTask",
    achGoldTaskName: "GoldTask",
    achWoodFcName: "WoodFc",
    achCopperFcName: "CopperFc",
    achSilverFcName: "SilverFc",
    achGoldFcName: "GoldFc",
    achWoodRushName: "WoodRush",
    achCopperRushName: "CopperRush",
    achSilverRushName: "SilverRush",
    achGoldRushName: "GoldRush",
    achWoodStreakName: "WoodStreak",
    achCopperStreakName: "CopperStreak",
    achSilverStreakName: "SilverStreak",
    achGoldStreakName: "GoldStreak",

    achWoodTaskDesc: "Ukończ 1 zadanie",
    achCopperTaskDesc: "Ukończ 5 zadań",
    achSilverTaskDesc: "Ukończ 20 zadań",
    achGoldTaskDesc: "Ukończ 50 zadań",
    achWoodFcDesc: "Zgadnij 1 fiszkę",
    achCopperFcDesc: "Zgadnij 10 fiszek",
    achSilverFcDesc: "Zgadnij 50 fiszek",
    achGoldFcDesc: "Zgadnij 250 fiszek",
    achWoodRushDesc: "Osiągnij wynik 5 w Fiszkach Rush",
    achCopperRushDesc: "Osiągnij wynik 15 w Fiszkach Rush",
    achSilverRushDesc: "Osiągnij wynik 25 w Fiszkach Rush",
    achGoldRushDesc: "Osiągnij wynik 45 w Fiszkach Rush",
    achWoodStreakDesc: "Osiągnij serię 1-dniową",
    achCopperStreakDesc: "Osiągnij serię 3-dniową",
    achSilverStreakDesc: "Osiągnij serię 7-dniową",
    achGoldStreakDesc: "Osiągnij serię 14-dniową",


    achYouHaveUnlocked:"Odblokowałeś %a z 12 osiągnięć",
    achLogInToSee:"Zaloguj się aby zobaczyć osiągnięcia",




  };
}

const List<MapLocale> locales = [
  MapLocale(LocaleData.englishLang, LocaleData.en),
  MapLocale(LocaleData.polishLang, LocaleData.pl)
];

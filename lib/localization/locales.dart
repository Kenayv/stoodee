import 'package:flutter_localization/flutter_localization.dart';

mixin LocaleData {

  //basic dialogs
  static const String dialogCancel="Cancel";




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



  //account


  static const String accountYourStats = "Your stats:";
  static const String accountCompletedFlashcards = "Completed flashcards:";
  static const String accountFCRushHighScore = "Fc Rush Highscore:";
  static const String accountCompletedTasks = "Completed tasks:";
  static const String accountIncompleteTasks = "Incomplete tasks:";
  static const String accountTaskCompletionRate = "Task completion rate:";
  static const String accountCurrentStreak = "Current streak:";
  static const String accountLongestStreak = "Longest streak";
  static const String accountDays="days";
  static const String accountDay="day";
  static const String accountLogOut="Log-out";
  static const String accountLogInToSeeStats="Log-in to see stats!";
  static const String accountNotLoggedIn="Not logged in!";
  //account settings dialog
  static const String accountUserSettingsTitle="User settings";
  static const String accountSettingsInfo="Leave the fields below empty to keep them unchanged.";
  static const String accountNewUsername="Username";
  static const String accountDailyTasksGoal="Daily tasks goal";
  static const String accountDailyFlashcardGoal="Daily flashcards goal";
  static const String accountSelectTheme="Select theme";
  static const String accountLightTheme="Light theme";
  static const String accountDarkTheme="Dark theme";
  static const String accountChangeWarning="warning! change resets today's progress.";



  static const String polishLang = 'pl';
  static const String englishLang = 'en';

  static const Map<String, dynamic> en = {
    dialogCancel:"Cancel",
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




  accountYourStats: "Your stats:",
  accountCompletedFlashcards: "Completed flashcards",
  accountFCRushHighScore: "Fc Rush Highscore",
  accountCompletedTasks: "Completed tasks",
  accountIncompleteTasks: "Incomplete tasks",
  accountTaskCompletionRate: "Task completion rate",
  accountCurrentStreak: "Current streak",
  accountLongestStreak: "Longest streak",
  accountDay:"day",
  accountDays:"days",
  accountLogOut:"Log-out",
  accountLogInToSeeStats:"Log-in to see stats!",
  accountNotLoggedIn:"Not logged in!",

   accountUserSettingsTitle:"User settings",
   accountSettingsInfo:"Leave the fields below empty to keep them unchanged.",
   accountNewUsername:"Username",
   accountDailyTasksGoal:"Daily tasks goal",
   accountDailyFlashcardGoal:"Daily flashcards goal",
   accountSelectTheme:"Select theme",
   accountLightTheme:"Light theme",
   accountDarkTheme:"Dark theme",
   accountChangeWarning:"warning! change resets today's progress.",




};

  static const Map<String, dynamic> pl = {
    dialogCancel:"Anuluj",
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
    mainTodaysGoal:"Dzisiejsze cele:",
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


    accountYourStats: "Twoje statystyki",
    accountCompletedFlashcards: "Ukończone fiszki",
    accountFCRushHighScore: "Rekord Fc Rush",
    accountCompletedTasks: "Ukończone zadania",
    accountIncompleteTasks: "Nieukończone zadania",
    accountTaskCompletionRate: "Procent ukończenia zadań",
    accountCurrentStreak: "Obecna seria",
    accountLongestStreak: "Najdłuższa seria",
    accountDays:"dni",
    accountDay:"dzień",
    accountLogOut:"Wyloguj się",
    accountLogInToSeeStats:"Brak konta!",
    accountNotLoggedIn:"Nie jesteś zalogowany!",



    accountUserSettingsTitle:"Ustawienia",
    accountSettingsInfo:"Pozostaw pole poniżej puste, jeśli nie chcesz ich zmieniać.",
    accountNewUsername:"Nazwa użytkownika",
    accountDailyTasksGoal:"Dzienny cel zadań",
    accountDailyFlashcardGoal:"Dzienny cel fiszek",
    accountSelectTheme:"Wybierz motyw",
    accountLightTheme:"Jasny motyw",
    accountDarkTheme:"Ciemny motyw",
    accountChangeWarning:"uwaga! zmiana resetuje dzisiejszy postęp",




  };
}

const List<MapLocale> locales = [
  MapLocale(LocaleData.englishLang, LocaleData.en),
  MapLocale(LocaleData.polishLang, LocaleData.pl)
];

import 'package:flutter_localization/flutter_localization.dart';

mixin LocaleData {
  //basic dialogs
  static const String dialogCancel = "Cancel";
  static const String dialogAddTask = "AddTask";
  static const String dialogtaskText = "Task text";
  static const String dialogAddFlashcardSet = "Add Flashcard Set";
  static const String dialogSetName = "Set name";
  static const String dialogAddFlashcard = "Add Flashcard";
  static const String dialogFrontText = "Front text";
  static const String dialogBackText = "Back text";
  static const String dialogSelectFcModeTitle = "Select flashcards mode";
  static const String dialogSelectFcModeDescription =
      "Select preferred game mode:";
  static const String dialogNormalMode = "Normal mode";
  static const String dialogFcRushMode = "Flashcards Rush";
  static const String dialogAreYouSureDeleteFlashcard =
      "Are you sure you want to delete this flashcard?";
  static const String dialogRushIsOver = "Rush is over! Score: ";
  static const String dialogRushOverDescripiton =
      "You have achieved a score of %a points!";

  static const String dialogMissCount = "With a miss count of: %a.";

  static const String dialogPreviousHighScore =
      "Your previous highscore was %a.";
  static const String dialogContinue = "Continue";
  static const String dialogDeleteTitle = "Deleting %a";

  static const String dialogDeleteSetDescription =
      "Are you sure you want to delete this set?";
  static const String dialogNewHighScore = "New HighScore! Score: ";

  //fcreader
  static const String fcReaderDeleteButton = "Delete";


  //emailverif
  static const String emailVerifTitle="Verify Your Email";
  static const String emailVerifDesc1="One more thing! You haven't verified your email yet!";
  static const String emailVerifDesc2="We have sent an email verification link to you";
  static const String emailVerifDesc3="To verify your account, Click the link inside of it";
  static const String emailVerifDontSeeLink="Don't see a link? click here to resend verification email";


  //fcrush
  static const String fcRushTimeRemaining = "Time remaining: ";
  static const String fcRushScore = "Score";
  static const String fcRushMisses = "Misses";
  static const String fcRushMissesNone = "None";
  static const String fcRushWrong = "Wrong";
  static const String fcRushCorrect = "Correct";

  //empty fcreader
  static const String fcEmptyReaderempty = "empty";
  static const String fcEmptyReaderFrontText =
      "add a flashcard before stoodying";

  static const String fcEmptyReaderBackText = "pls";
  static const String fcEmptyReaderAddFlashcard = "Add flashcard";

  //pagescaffold
  static const String page1Title = "ToDo";
  static const String page2Title = "FlashCards";
  static const String page3Title = "Home";
  static const String page4Title = "Achievements";
  static const String page5Title = "Account";

  //loginpage
  static const String loginSkip = "skip log-in";
  static const String loginTypewriter1 = "Thanks for being with us :D";
  static const String loginTypewriter2 = "It means a lot! ^^";
  static const String loginTypewriter3 = "~Stoodee team";
  static const String loginTitle = "Log-in";
  static const String loginHintEmail = "E-mail";
  static const String loginHintPassword = "Password";
  static const String loginSignUp = "Sign-up";
  static const String loginRememberMe = "Remember me";

  //TODO: TRANSLATING SNACKBARS

  static const String snackBarWhoops = "Whoops...";
  static const String snackBarNeutral = "Hey!";
  static const String snackBarSuccess = "Success!";
  static const String snackBarLogInFirst = "Log-in first";
  static const String snackBarSetEmpty =
      "Current set is empty. Add some flashcards before studying!";
  static const String snackBarAllFieldsFilled =
      "Make sure all fields are filled!";
  static const String snackBarSyncedWithCloud = "Succesfully synced with cloud";
  static const String snackBarNotSoFast = "Cannot sync so frequently";
  static const String snackBarErrorCode = "Error: code: ";
  static const String snackBarNoInternet = "Could not find internet connection";
  static const String snackBarFlashcardAdded = "Flashcard added";
  static const String snackBarFlashcarNotAdded = "Flashcard could not be added";
  static const String snackBarIntroduction =
      "This feature is unavalible in introduction\nTo try it out, finish the intro :D";
  static const String snackBarAccountAlreadyExists =
      "Account with this e-mail addresss already exists";
  static const String snackBarIncorrectEmail = "Incorrect email or password";
  static const String snackBarEmailAndPassword =
      "Enter email and password to Sign-Up";
  static const String snackBarPassword =
      "Password must contain at least 8 characters";

  //mainpage
  static const String mainDidYouKnow = "Did you know that...?";
  static const String mainTodaysGoal = "Today's goal:";
  static const String mainCurrentDaysStreak = "Current days streak:";

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
  static const String achWoodRushDesc =
      "Achieve a score of 5 in Flashcards Rush";
  static const String achCopperRushDesc =
      "Achieve a score of 15 in Flashcards Rush";
  static const String achSilverRushDesc =
      "Achieve a score of 25 in Flashcards Rush";
  static const String achGoldRushDesc =
      "Achieve a score of 45 in Flashcards Rush";
  static const String achWoodStreakDesc = "Achieve a 1-day Streak";
  static const String achCopperStreakDesc = "Achieve a 3-day Streak";
  static const String achSilverStreakDesc = "Achieve a 7-day Streak";
  static const String achGoldStreakDesc = "Achieve a 14-day Streak";

  static const String achYouHaveUnlocked =
      "You have unlocked %a out of 12 achievements";
  static const String achLogInToSee = "Log-in to see achievements";

  //account

  static const String accountYourStats = "Your stats:";
  static const String accountCompletedFlashcards = "Completed flashcards:";
  static const String accountFCRushHighScore = "Fc Rush Highscore:";
  static const String accountCompletedTasks = "Completed tasks:";
  static const String accountIncompleteTasks = "Incomplete tasks:";
  static const String accountTaskCompletionRate = "Task completion rate:";
  static const String accountCurrentStreak = "Current streak:";
  static const String accountLongestStreak = "Longest streak";
  static const String accountDays = "days";
  static const String accountDay = "day";
  static const String accountLogOut = "Log-out";
  static const String accountLogInToSeeStats = "Log-in to see stats!";
  static const String accountNotLoggedIn = "Not logged in!";
  //account settings dialog
  static const String accountUserSettingsTitle = "User settings";
  static const String accountSettingsInfo =
      "Leave the fields below empty to keep them unchanged.";
  static const String accountNewUsername = "Username";
  static const String accountDailyTasksGoal = "Daily tasks goal";
  static const String accountDailyFlashcardGoal = "Daily flashcards goal";
  static const String accountSelectTheme = "Select theme";
  static const String accountLightTheme = "Light theme";
  static const String accountDarkTheme = "Dark theme";
  static const String accountChangeWarning =
      "warning! change resets today's progress.";

  static const String fcreaderShowAfter = "show after:";
  static const String fcreaderDialogAreYouSure =
      "Are you sure you want to delete this flashcard?";
  static const String fcreaderEasy = "Easy";
  static const String fcreaderMedium = "Medium";
  static const String fcreaderHard = "Hard";

  static const String fcreaderMinute = "minute";
  static const String fcreaderMinutes = "minutes";
  static const String fcreaderHour = "hour";
  static const String fcreaderHours = "hours";

  static const String fcPageAll = "All:";
  static const String fcPageReady = "Active:";

  static const String introHelpYouStoodee = "We will help you stoodee 😎";
  static const String introTaskListTitle = "Task list";
  static const String introTaskListPoint1 =
      "Swipe left, and the task will be deleted and marked as incomplete.";
  static const String introTaskListPoint2 =
      "Swipe right, and the task will be marked as finished.";
  static const String introTaskOrganize = "Organize your Stoodying";
  static const String introfcTitle = "Flashcards";
  static const String introfcPoint1 =
      "Tap on a plus icon, and flashcard will be added.";
  static const String introfcPoint2 =
      "Tap on the whole set, and you will open it.";
  static const String introfcPoint3 = "Hold the set, and it will be deleted.";
  static const String introEmpower = "Empower your knowledge";
  static const String introHaveFun = "Have fun learning!";
  static const String introYapping =
      "In settings you will be able to set how many tasks and flashcards you can do per day";
  static const String introDone = "Done";

  static const String polishLang = 'pl';
  static const String englishLang = 'en';

  static const Map<String, dynamic> en = {
    dialogCancel: "Cancel",
    page1Title: "ToDo",
    page2Title: "FlashCards",
    page3Title: "Home",
    page4Title: "Achievements",
    page5Title: "Account",
    loginSkip: "Skip log-in",
    loginTypewriter1: "Thanks for being with us :D",
    loginTypewriter2: "It means a lot! ^^",
    loginTypewriter3: "~Stoodee team",
    loginTitle: "Log-in",
    loginHintEmail: "E-mail",
    loginHintPassword: "Password",
    loginSignUp: "Sign-up",
    loginRememberMe: "Remember me",
    mainDidYouKnow: "Did you know that...?",
    mainTodaysGoal: "Today's goal:",
    mainCurrentDaysStreak: "Current days streak:",
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
    achWoodTaskDesc: "Complete 1 task",
    achCopperTaskDesc: "Complete 5 tasks",
    achSilverTaskDesc: "Complete 20 tasks",
    achGoldTaskDesc: "Complete 50 tasks",
    achWoodFcDesc: "Finish 1 flashcard",
    achCopperFcDesc: "Finish 10 Flashcards",
    achSilverFcDesc: "Finish 50 Flashcards",
    achGoldFcDesc: "Finish 250 Flashcards",
    achWoodRushDesc: "Achieve a score of 5 in Flashcards Rush",
    achCopperRushDesc: "Achieve a score of 15 in Flashcards Rush",
    achSilverRushDesc: "Achieve a score of 25 in Flashcards Rush",
    achGoldRushDesc: "Achieve a score of 45 in Flashcards Rush",
    achWoodStreakDesc: "Achieve a 1-day Streak",
    achCopperStreakDesc: "Achieve a 3-day Streak",
    achSilverStreakDesc: "Achieve a 7-day Streak",
    achGoldStreakDesc: "Achieve a 14-day Streak",
    achYouHaveUnlocked: "You have unlocked %a out of 12 achievements",
    achLogInToSee: "Log-in to see achievements",
    accountYourStats: "Your stats:",
    accountCompletedFlashcards: "Completed flashcards",
    accountFCRushHighScore: "Fc Rush Highscore",
    accountCompletedTasks: "Completed tasks",
    accountIncompleteTasks: "Incomplete tasks",
    accountTaskCompletionRate: "Task completion rate",
    accountCurrentStreak: "Current streak",
    accountLongestStreak: "Longest streak",
    accountDay: "day",
    accountDays: "days",
    accountLogOut: "Log-out",
    accountLogInToSeeStats: "Log-in to see stats!",
    accountNotLoggedIn: "Not logged in!",
    accountUserSettingsTitle: "User settings",
    accountSettingsInfo: "Leave the fields below empty to keep them unchanged.",
    accountNewUsername: "Username",
    accountDailyTasksGoal: "Daily tasks goal",
    accountDailyFlashcardGoal: "Daily flashcards goal",
    accountSelectTheme: "Select theme",
    accountLightTheme: "Light theme",
    accountDarkTheme: "Dark theme",
    accountChangeWarning: "warning! change resets today's progress.",
    fcreaderShowAfter: "show after:",
    fcreaderDialogAreYouSure: "Are you sure you want to delete this flashcard?",
    fcreaderEasy: "Easy",
    fcreaderMedium: "Medium",
    fcreaderHard: "Hard",
    fcreaderMinute: "minute",
    fcreaderMinutes: "minutes",
    fcreaderHour: "hour",
    fcreaderHours: "hours",
    fcPageAll: "All:",
    fcPageReady: "Active:",
    introHelpYouStoodee: "We will help you stoodee 😎",
    introTaskListTitle: "Task list",
    introTaskListPoint1:
        "Swipe left, and the task will be deleted and marked as incomplete.",
    introTaskListPoint2:
        "Swipe right, and the task will be marked as finished.",
    introTaskOrganize: "Organize your Stoodying",
    introfcTitle: "Flashcards",
    introfcPoint1: "Tap on a plus icon, and flashcard will be added.",
    introfcPoint2: "Tap on the whole set, and you will open it.",
    introfcPoint3: "Hold the set, and it will be deleted.",
    introEmpower: "Empower your knowledge",
    introHaveFun: "Have fun learning!",
    introYapping:
        "In settings you will be able to set how many tasks and flashcards you can do per day",
    introDone: "All done",
    dialogAddTask: "AddTask",
    dialogtaskText: "Task text",
    dialogAddFlashcardSet: "Add Flashcard Set",
    dialogSetName: "Set name",
    dialogAddFlashcard: "Add Flashcard",
    dialogFrontText: "Front text",
    dialogBackText: "Back text",
    dialogSelectFcModeTitle: "Select flashcards mode",
    dialogSelectFcModeDescription: "Select preferred game mode:",
    dialogNormalMode: "Normal mode",
    dialogFcRushMode: "Flashcards Rush",
    dialogRushIsOver: "Rush is over! Score: ",
    dialogRushOverDescripiton:
        "You have achieved a score of %a points!\nWith a miss count of: %b.\nYour previous highscore was %c.",
    dialogContinue: "Continue",
    dialogDeleteTitle: "Deleting %a",
    dialogDeleteSetDescription: "Are you sure you want to delete this set?",
    fcReaderDeleteButton: "Delete",
    fcRushTimeRemaining: "Time remaining: ",
    fcRushScore: "Score",
    fcRushMisses: "Misses",
    fcRushMissesNone: "None",
    fcRushWrong: "Wrong",
    fcRushCorrect: "Correct",
    fcEmptyReaderempty: "empty",
    fcEmptyReaderFrontText: "add a flashcard before stoodying",
    fcEmptyReaderBackText: "pls",
    fcEmptyReaderAddFlashcard: "Add flashcard",
    dialogNewHighScore: "New HighScore! Score: ",
    snackBarWhoops: "Whoops...",
    snackBarNeutral: "Hey!",
    snackBarSuccess: "Success!",
    snackBarLogInFirst: "Log-in first",
    snackBarSetEmpty:
        "Current set is empty. Add some flashcards before studying!",
    snackBarAllFieldsFilled: "Make sure all fields are filled!",
    snackBarSyncedWithCloud: "Succesfully synced with cloud",
    snackBarNotSoFast: "Cannot sync so frequently",
    snackBarErrorCode: "Error: code: ",
    snackBarNoInternet: "Could not find internet connection",
    snackBarFlashcardAdded: "Flashcard added",
    snackBarFlashcarNotAdded: "Flashcard could not be added",
    snackBarIntroduction:
        "This feature is unavalible in introduction\nTo try it out, finish the intro :D",
    snackBarAccountAlreadyExists:
        "Account with this e-mail addresss already exists",
    snackBarIncorrectEmail: "Incorrect email or password",
    snackBarEmailAndPassword: "Enter email and password to Sign-Up",
    snackBarPassword: "Password must contain at least 8 characters",



   emailVerifTitle:"Verify Your Email",
   emailVerifDesc1:"One more thing! You haven't verified your email yet!",
   emailVerifDesc2:"We have sent an email verification link to you",
   emailVerifDesc3:"To verify your account, Click the link inside of it",
   emailVerifDontSeeLink:"Don't see a link? click here to resend verification email",


  };

  static const Map<String, dynamic> pl = {
    dialogCancel: "Anuluj",
    page1Title: "Lista zadań",
    page2Title: "Fiszki",
    page3Title: "Strona główna",
    page4Title: "Osiągnięcia",
    page5Title: "Konto",
    loginSkip: "Pomiń logowanie",
    loginTypewriter1: "Dziękujemy za bycie z nami :D",
    loginTypewriter2: "To wiele znaczy! ^^",
    loginTypewriter3: "~Zespół Stoodee",
    loginTitle: "Zaloguj się",
    loginHintEmail: "E-mail",
    loginHintPassword: "Hasło",
    loginSignUp: "Zarejestruj się",
    loginRememberMe: "Zapamiętaj mnie",
    mainDidYouKnow: "Czy wiesz, że...?",
    mainTodaysGoal: "Dzisiejsze cele:",
    mainCurrentDaysStreak: "Aktualna seria:",
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
    achWoodFcDesc: "Odgadnij 1 fiszkę",
    achCopperFcDesc: "Odgadnij 10 fiszek",
    achSilverFcDesc: "Odgadnij 50 fiszek",
    achGoldFcDesc: "Odgadnij 250 fiszek",
    achWoodRushDesc: "Osiągnij wynik 5 w Fiszkach Rush",
    achCopperRushDesc: "Osiągnij wynik 15 w Fiszkach Rush",
    achSilverRushDesc: "Osiągnij wynik 25 w Fiszkach Rush",
    achGoldRushDesc: "Osiągnij wynik 45 w Fiszkach Rush",
    achWoodStreakDesc: "Osiągnij 1-dniową serię",
    achCopperStreakDesc: "Osiągnij 3-dniową serię",
    achSilverStreakDesc: "Osiągnij 7-dniową serię",
    achGoldStreakDesc: "Osiągnij 14-dniową serię",
    achYouHaveUnlocked: "Odblokowano %a z 12 osiągnięć",
    achLogInToSee: "Zaloguj się, aby zobaczyć osiągnięcia",
    accountYourStats: "Twoje statystyki",
    accountCompletedFlashcards: "Ukończone fiszki",
    accountFCRushHighScore: "Rekord Fc Rush",
    accountCompletedTasks: "Ukończone zadania",
    accountIncompleteTasks: "Nieukończone zadania",
    accountTaskCompletionRate: "Procent ukończenia zadań",
    accountCurrentStreak: "Obecna seria",
    accountLongestStreak: "Najdłuższa seria",
    accountDays: "dni",
    accountDay: "dzień",
    accountLogOut: "Wyloguj się",
    accountLogInToSeeStats: "Brak konta!",
    accountNotLoggedIn: "Nie jesteś zalogowany!",
    accountUserSettingsTitle: "Ustawienia",
    accountSettingsInfo:
        "Pozostaw pole poniżej puste, jeśli nie chcesz ich zmieniać.",
    accountNewUsername: "Nazwa użytkownika",
    accountDailyTasksGoal: "Dzienny cel zadań",
    accountDailyFlashcardGoal: "Dzienny cel fiszek",
    accountSelectTheme: "Wybierz motyw",
    accountLightTheme: "Jasny motyw",
    accountDarkTheme: "Ciemny motyw",
    accountChangeWarning: "uwaga! zmiana resetuje dzisiejszy postęp",
    fcreaderShowAfter: "pokaż za:",
    fcreaderDialogAreYouSure: "Czy jesteś pewien że chcesz usunąć tę fiszkę?",
    fcreaderEasy: "Łatwe",
    fcreaderMedium: "Średnie",
    fcreaderHard: "Ciężkie",
    fcreaderMinute: "minute",
    fcreaderMinutes: "minut(y)",
    fcreaderHour: "godzine",
    fcreaderHours: "godziny",
    fcPageAll: "Wszystkie:",
    fcPageReady: "Do zrobienia:",
    introHelpYouStoodee: "Pomożemy ci w uczeniu 😎",
    introTaskListTitle: "Lista zadań",
    introTaskListPoint1:
        "Przesuń w lewo a zadanie zostanie usunięte i zaliczone jako niewykonane.",
    introTaskListPoint2: "Przesuń w prawo zadanie zostanie wykonane",
    introTaskOrganize: "Zorganizuj swoją nauke",
    introfcTitle: "Fiszki",
    introfcPoint1: "Kliknij na plusa, fiszka zostanie dodana",
    introfcPoint2: "Kliknij na zestaw, to go otworzysz.",
    introfcPoint3: "Przytrzymaj zestaw, to go usuniesz.",
    introEmpower: "Utrwal swoją wiedzę",
    introHaveFun: "Baw się dobrze!",
    introYapping:
        "W ustawieniach będziesz mógł ustawić, ile zadań i fiszek chcesz wykonać dziennie",
    introDone: "Wszystko gotowe",
    dialogAddTask: "Dodaj zadanie",
    dialogtaskText: "Tytuł zadania",
    dialogAddFlashcardSet: "Dodaj zestaw fiszek",
    dialogSetName: "Tytuł zestawu",
    dialogAddFlashcard: "Dodaj Fiszke",
    dialogFrontText: "Przód",
    dialogBackText: "Tył",
    dialogSelectFcModeTitle: "Wybierz tryb nauki",
    dialogSelectFcModeDescription: "Wybierz tryb otwarcia zestawu fiszek:",
    dialogNormalMode: "Tryb normalny",
    dialogFcRushMode: "Tryb FlashcardRush",
    dialogRushIsOver: "Koniec! Wynik: ",
    dialogRushOverDescripiton:
        "Uzyskałeś %a punktów!\nZ ilością błędów: %a .\nTwoj poprzedni rekord: %a .",
    dialogContinue: "Kontynuuj",
    dialogDeleteTitle: "Usuwanie %a",
    dialogDeleteSetDescription: "Czy na pewno chcesz usunąć ten zestaw?",
    fcReaderDeleteButton: "Usuń",
    fcRushTimeRemaining: "Pozostały czas: ",
    fcRushScore: "Wynik",
    fcRushMisses: "Błędy",
    fcRushMissesNone: "Brak",
    fcRushWrong: "Źle",
    fcRushCorrect: "Dobrze",
    fcEmptyReaderempty: "puste",
    fcEmptyReaderFrontText: "Dodaj fiszke przed uczeniem sie",
    fcEmptyReaderBackText: "prosze",
    fcEmptyReaderAddFlashcard: "Dodaj fiszke",
    dialogNewHighScore: "Nowy rekord! Wynik: ",
    snackBarWhoops: "Whoops...",
    snackBarNeutral: "Hej!",
    snackBarSuccess: "Sukces!",
    snackBarLogInFirst: "Najpierw się zaloguj",
    snackBarSetEmpty: "Zestaw jest pusty. Najpierw dodaj fiszkę!",
    snackBarAllFieldsFilled: "Upewnij się, że wszystkie pola są wypełnione!",
    snackBarSyncedWithCloud: "Pomyślnie zsynchronizowano z chmurą",
    snackBarNotSoFast: "Zwolnij troche",
    snackBarErrorCode: "Error: kod: ",
    snackBarNoInternet: "Nie można znaleźć połączenia z internetem",
    snackBarFlashcardAdded: "Dodano fiszke",
    snackBarFlashcarNotAdded: "Nie udało się dodać fiszki",
    snackBarIntroduction:
        "Ta funkcjonalność nie jest dostępna we wstępie.\nAby wypróbować, zakończ wprowazenie :D",
    snackBarAccountAlreadyExists: "Konto z takim adresem email już istnieje",
    snackBarIncorrectEmail: "Niepoprawny email lub hasło",
    snackBarEmailAndPassword:
        "Wpisz email oraz hasło, aby się zalogować/zarejestrować",
    snackBarPassword: "Hasło musi mieć conajmniej 8 znaków",



    emailVerifTitle:"Zweryfikuj swój email",
    emailVerifDesc1:"Jeszcze jedno! Twój email jest niezweryfikowany!",
    emailVerifDesc2:"Wysłaliśmy ci link do weryfikacji",
    emailVerifDesc3:"Aby zweryfikować konto, kliknij w link we wiadomości",
    emailVerifDontSeeLink:"Nie przyszło? Kliknij tutaj, wyślemy jeszcze raz",



  };
}

const List<MapLocale> locales = [
  MapLocale(LocaleData.englishLang, LocaleData.en),
  MapLocale(LocaleData.polishLang, LocaleData.pl)
];

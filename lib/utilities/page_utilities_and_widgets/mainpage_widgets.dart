import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:stoodee/services/local_crud/local_database_service/database_user.dart';
import 'package:stoodee/stoodee_icons_icons.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:stoodee/utilities/reusables/stoodee_gauge.dart';
import 'package:stoodee/utilities/reusables/stoodee_linear_gauge.dart';
import 'package:stoodee/utilities/theme/theme.dart';

import '../../localization/locales.dart';
import '../../main.dart';

const Duration defaultWriterSpeed = Duration(milliseconds: 80);
List<String> funFactsListEN = [
  "Studying while chewing gum can increase your focus and concentration.",
  "Research suggests that studying in short bursts with breaks in between can enhance retention and understanding.",
  "Drawing diagrams and doodling while studying can help reinforce concepts and improve memory recall.",
  "Playing instrumental music in the background while studying can create a conducive environment for learning.",
  "Teaching someone else what you've learned is one of the most effective ways to solidify your own understanding.",
  "Regular exercise has been shown to improve cognitive function and can enhance your ability to study effectively.",
  "Studying in different environments can prevent monotony and stimulate creativity.",
  "Using mnemonic devices, such as acronyms or rhymes, can aid in remembering complex information.",
  "Consuming dark chocolate in moderation can boost brain function and improve focus.",
  "Taking short naps (around 20-30 minutes) can enhance memory consolidation and rejuvenate your mind for further studying.",
  "Writing notes by hand instead of typing them can lead to better comprehension and retention of material.",
  "The Pomodoro Technique, which involves studying for 25 minutes and then taking a 5-minute break, is a popular method for maximizing productivity.",
  "Sniffing rosemary essential oil has been shown to enhance memory and alertness.",
  "Chewing on a pencil while studying might actually help you remember information better due to the sensory experience.",
  "Studying before bed can improve retention, as the brain continues to process information during sleep.",
  "Writing practice exams for yourself is an effective way to prepare for actual tests or exams.",
  "Explaining concepts out loud in your own words can reinforce learning and highlight areas of weakness.",
  "Creating a designated study space can signal to your brain that it's time to focus and can improve study habits.",
  "Taking breaks to stretch or do light physical activity can increase blood flow to the brain and improve cognitive function.",
  "Using different colored pens for notes can help organize information and make it easier to recall.",
  "Studies have shown that moderate caffeine consumption can enhance alertness and cognitive performance.",
  "Incorporating humor into your study sessions can make learning more enjoyable and memorable.",
  "Taking handwritten notes during lectures can lead to better understanding and retention compared to typing notes on a laptop.",
  "Discussing and debating topics with peers can deepen understanding and provide new perspectives.",
  "Creating mind maps or concept maps can help visualize relationships between ideas and aid in understanding complex concepts.",
  "Studies suggest that getting enough sleep is crucial for optimal cognitive function, memory consolidation, and learning.",
  "Breaking down large tasks into smaller, manageable chunks can reduce overwhelm and improve productivity.",
  "Practicing meditation or mindfulness techniques can reduce stress and improve focus during study sessions.",
  "Using online resources such as educational videos and interactive quizzes can supplement traditional study methods and enhance learning.",
  "Rewarding yourself with small treats or breaks after completing study goals can provide motivation and reinforce positive study habits.",
];

List<String> funFactsListPL = [
  "Nauka podczas żucia gumy może zwiększyć twoją koncentrację i skupienie.",
  "Badania sugerują, że nauka w krótkich seriach z przerwami pomiędzy może zwiększyć retencję i zrozumienie.",
  "Rysowanie diagramów i bazgranie podczas nauki może pomóc w wzmocnieniu pojęć i poprawie przypominania.",
  "Odtwarzanie muzyki instrumentalnej w tle podczas nauki może stworzyć sprzyjające warunki do nauki.",
  "Nauczanie kogoś innego tego, czego się nauczyłeś, jest jednym z najskuteczniejszych sposobów na utrwalenie własnego zrozumienia.",
  "Regularne ćwiczenia fizyczne wykazują poprawę funkcji poznawczych i mogą zwiększyć twoją efektywność w nauce.",
  "Nauka w różnych środowiskach może zapobiec monotonii i pobudzić kreatywność.",
  "Stosowanie mnemoników, takich jak akronimy czy rymy, może pomóc w zapamiętywaniu skomplikowanych informacji.",
  "Spożywanie ciemnej czekolady z umiarem może poprawić funkcje mózgu i zwiększyć koncentrację.",
  "Krótkie drzemki (około 20-30 minut) mogą zwiększyć konsolidację pamięci i odmłodzić umysł do dalszej nauki.",
  "Pisanie notatek ręcznie zamiast ich wpisywania może prowadzić do lepszego zrozumienia i retencji materiału.",
  "Technika Pomodoro, polegająca na nauce przez 25 minut, a następnie na 5-minutowej przerwie, jest popularną metodą maksymalizacji produktywności.",
  "Wąchanie olejku eterycznego z rozmarynu wykazano, że poprawia pamięć i czujność.",
  "Żucie ołówka podczas nauki może faktycznie pomóc w lepszym zapamiętywaniu informacji dzięki sensorycznemu doświadczeniu.",
  "Nauka przed snem może poprawić retencję, ponieważ mózg kontynuuje przetwarzanie informacji podczas snu.",
  "Pisanie egzaminów próbnych dla siebie jest skutecznym sposobem na przygotowanie się do rzeczywistych testów lub egzaminów.",
  "Wyjaśnianie koncepcji na głos własnymi słowami może wzmocnić naukę i podkreślić obszary słabości.",
  "Stworzenie wyznaczonej przestrzeni do nauki może sygnalizować mózgowi, że nadszedł czas na skupienie się i poprawić nawyki naukowe.",
  "Robienie przerw na rozciąganie lub lekką aktywność fizyczną może zwiększyć przepływ krwi do mózgu i poprawić funkcje poznawcze.",
  "Używanie różnych kolorowych długopisów do notatek może pomóc w organizacji informacji i ułatwić ich przypomnienie.",
  "Badania wykazały, że umiarkowane spożycie kofeiny może poprawić czujność i wydajność poznawczą.",
  "Włączenie humoru do sesji nauki może uczynić naukę bardziej przyjemną i zapamiętywalną.",
  "Pisanie ręcznych notatek podczas wykładów może prowadzić do lepszego zrozumienia i retencji w porównaniu z wpisywaniem notatek na laptopie.",
  "Omawianie i debatowanie tematów z rówieśnikami może pogłębić zrozumienie i dostarczyć nowych perspektyw.",
  "Tworzenie map myśli lub map pojęć może pomóc wizualizować relacje między pomysłami i wspomagać zrozumienie skomplikowanych pojęć.",
  "Badania sugerują, że wystarczająca ilość snu jest kluczowa dla optymalnych funkcji poznawczych, konsolidacji pamięci i nauki.",
  "Rozbijanie dużych zadań na mniejsze, łatwiejsze do zarządzania części może zmniejszyć przytłoczenie i poprawić produktywność.",
  "Praktykowanie medytacji lub technik uważności może zmniejszyć stres i poprawić koncentrację podczas sesji nauki.",
  "Korzystanie z zasobów online, takich jak edukacyjne filmy wideo i interaktywne quizy, może uzupełnić tradycyjne metody nauki i poprawić naukę.",
  "Nagradzanie siebie małymi przysmakami lub przerwami po osiągnięciu celów naukowych może zapewnić motywację i wzmocnić pozytywne nawyki naukowe.",
];


Future<void> _showFunFactDialog(BuildContext context, String text) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          children: [
            defaultBlurFilter(),
            Center(
              child: AlertDialog(
                contentPadding: const EdgeInsets.all(20),
                backgroundColor: usertheme.backgroundColor,
                content: SizedBox(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       Text(
                        LocaleData.mainDidYouKnow.getString(context),
                        style: const TextStyle(
                          color: Color.fromARGB(255, 88, 88, 88),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 10)),
                      Text(
                        text,
                        style: TextStyle(
                          color: usertheme.textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget buildFunFactBox({
  required BuildContext context,
}) {
  String animatedText;
  if(currentLocale==LocaleData.polishLang){
    funFactsListPL.shuffle();
    animatedText=funFactsListPL[0];
  }
  else if(currentLocale==LocaleData.englishLang){
    funFactsListEN.shuffle();
    animatedText=funFactsListEN[0];
  }
  else{
    funFactsListPL.shuffle();
    animatedText=funFactsListPL[0];

  }


  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () => _showFunFactDialog(context, animatedText),
    child: Container(
      height: MediaQuery.of(context).size.height * 0.11,
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: usertheme.backgroundColor.withOpacity(0.85),
        boxShadow: [
          BoxShadow(
            color: usertheme.basicShaddow,
            offset: const Offset(1, 1),
          )
        ],
      ),
      child: AnimatedTextKit(
        repeatForever: false,
        totalRepeatCount: 1,
        animatedTexts: [
          TypewriterAnimatedText(
            animatedText,
            textStyle: TextStyle(color: usertheme.textColor),
            speed: defaultWriterSpeed,
            cursor: "|",
          )
        ],
        onTap: () => _showFunFactDialog(context, animatedText),
      ),
    ),
  );
}

Row buildGaugeRow(BuildContext context, User user) {
  double gaugeContainerWidth = MediaQuery.of(context).size.width * 0.45;
  double gaugeContainerHeight = MediaQuery.of(context).size.height * 0.25;
  double iconSize = 38;

  //if user has exceeded dailyGoal, assign the daily goal value
  int tasksGaugeValue = user.tasksCompletedToday > user.dailyGoalTasks
      ? user.dailyGoalTasks
      : user.tasksCompletedToday;

  //if user has exceeded dailyGoal, assign the daily goal value
  int flashcardsGaugeValue =
      user.flashcardsCompletedToday > user.dailyGoalFlashcards
          ? user.dailyGoalFlashcards
          : user.flashcardsCompletedToday;

  Row row = Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      SizedBox(
        width: gaugeContainerWidth,
        height: gaugeContainerHeight,
        child: stoodeeGauge(
          value: tasksGaugeValue,
          max: user.dailyGoalTasks,
          titleIcon: Icon(StoodeeIcons.tasks,
              color: usertheme.primaryAppColor, size: iconSize),
          containerHeight: gaugeContainerHeight,
          redirectNumber: toDoPageRedirectIndex,
        ),
      ),
      SizedBox(
        width: gaugeContainerWidth,
        height: gaugeContainerHeight,
        child: stoodeeGauge(
            value: flashcardsGaugeValue,
            max: user.dailyGoalFlashcards,
            titleIcon: Icon(
              StoodeeIcons.flashcards,
              color: usertheme.primaryAppColor,
              size: iconSize,
            ),
            containerHeight: gaugeContainerHeight,
            redirectNumber: flashCardsPageRedirectIndex),
      ),
    ],
  );

  return row;
}

Row buildStreakGauge({
  required BuildContext context,
  required User user,
}) {
  double gaugeContainerHeight = MediaQuery.of(context).size.height * 0.25;

  Row row = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      stoodeeLinearGauge(
        value: user.currentDayStreak,
        max: user.streakHighscore,
        titleIcon: const Icon(Icons.account_circle_rounded),
        containerHeight: gaugeContainerHeight,
      )
    ],
  );

  return row;
}

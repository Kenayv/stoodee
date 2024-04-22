import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:stoodee/stoodee_icons_icons.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:stoodee/utilities/reusables/stoodee_gauge.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

const Duration defaultWriterSpeed = Duration(milliseconds: 80);

List<TypewriterAnimatedText> funFactsList = [
  TypewriterAnimatedText(
    "Studying while chewing gum can increase your focus and concentration.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Research suggests that studying in short bursts with breaks in between can enhance retention and understanding.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Drawing diagrams and doodling while studying can help reinforce concepts and improve memory recall.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Playing instrumental music in the background while studying can create a conducive environment for learning.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Teaching someone else what you've learned is one of the most effective ways to solidify your own understanding.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Regular exercise has been shown to improve cognitive function and can enhance your ability to study effectively.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Studying in different environments can prevent monotony and stimulate creativity.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Using mnemonic devices, such as acronyms or rhymes, can aid in remembering complex information.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Consuming dark chocolate in moderation can boost brain function and improve focus.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Taking short naps (around 20-30 minutes) can enhance memory consolidation and rejuvenate your mind for further studying.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Writing notes by hand instead of typing them can lead to better comprehension and retention of material.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "The Pomodoro Technique, which involves studying for 25 minutes and then taking a 5-minute break, is a popular method for maximizing productivity.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Sniffing rosemary essential oil has been shown to enhance memory and alertness.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Chewing on a pencil while studying might actually help you remember information better due to the sensory experience.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Studying before bed can improve retention, as the brain continues to process information during sleep.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Writing practice exams for yourself is an effective way to prepare for actual tests or exams.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Explaining concepts out loud in your own words can reinforce learning and highlight areas of weakness.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Creating a designated study space can signal to your brain that it's time to focus and can improve study habits.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Taking breaks to stretch or do light physical activity can increase blood flow to the brain and improve cognitive function.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Using different colored pens for notes can help organize information and make it easier to recall.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Studies have shown that moderate caffeine consumption can enhance alertness and cognitive performance.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Incorporating humor into your study sessions can make learning more enjoyable and memorable.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Taking handwritten notes during lectures can lead to better understanding and retention compared to typing notes on a laptop.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Discussing and debating topics with peers can deepen understanding and provide new perspectives.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Creating mind maps or concept maps can help visualize relationships between ideas and aid in understanding complex concepts.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Studies suggest that getting enough sleep is crucial for optimal cognitive function, memory consolidation, and learning.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Breaking down large tasks into smaller, manageable chunks can reduce overwhelm and improve productivity.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Practicing meditation or mindfulness techniques can reduce stress and improve focus during study sessions.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Using online resources such as educational videos and interactive quizzes can supplement traditional study methods and enhance learning.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
  TypewriterAnimatedText(
    "Rewarding yourself with small treats or breaks after completing study goals can provide motivation and reinforce positive study habits.",
    speed: defaultWriterSpeed,
    curve: Curves.decelerate,
  ),
];

Container buildFunFactBox({
  required BuildContext context,
}) {
  final funFacts = funFactsList;
  funFacts.shuffle();

  return Container(
    padding: const EdgeInsets.all(10),
    width: MediaQuery.of(context).size.width * 0.9,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(1, 1),
          )
        ]),
    child: Center(
      child: AnimatedTextKit(
        repeatForever: true,
        animatedTexts: funFacts,
      ),
    ),
  );
}




Row buildGaugeRow(){

  Row row=Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [


      Container(
        width: 150,
        height:250,
        child: StoodeeGauge(5,10,Icon(StoodeeIcons.tasks,color: primaryAppColor,size: 30))
      ),



      Container(
          width: 150,
          height:250,
          child: StoodeeGauge(1, 3,Icon(StoodeeIcons.flashcards,color: primaryAppColor,size: 30,))
      ),

    ],
  );



  return row;

}

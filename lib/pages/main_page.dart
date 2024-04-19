import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  static const Duration defaultWriterSpeed = Duration(milliseconds: 80);





  Future<List<AnimatedText>> getRandomFactList() async {
    return await compute(generateFunFactsList, defaultWriterSpeed);
  }

  static List<AnimatedText> generateFunFactsList(Duration defaultWriterSpeed) {
    List<TypewriterAnimatedText> funFactsList = [];
    final stopwatch = Stopwatch()..start();

    funFactsList.add(TypewriterAnimatedText("Studying while chewing gum can increase your focus and concentration.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Research suggests that studying in short bursts with breaks in between can enhance retention and understanding.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Drawing diagrams and doodling while studying can help reinforce concepts and improve memory recall.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Playing instrumental music in the background while studying can create a conducive environment for learning.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Teaching someone else what you've learned is one of the most effective ways to solidify your own understanding.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Regular exercise has been shown to improve cognitive function and can enhance your ability to study effectively.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Studying in different environments can prevent monotony and stimulate creativity.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Using mnemonic devices, such as acronyms or rhymes, can aid in remembering complex information.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Consuming dark chocolate in moderation can boost brain function and improve focus.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Taking short naps (around 20-30 minutes) can enhance memory consolidation and rejuvenate your mind for further studying.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Writing notes by hand instead of typing them can lead to better comprehension and retention of material.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("The Pomodoro Technique, which involves studying for 25 minutes and then taking a 5-minute break, is a popular method for maximizing productivity.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Sniffing rosemary essential oil has been shown to enhance memory and alertness.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Chewing on a pencil while studying might actually help you remember information better due to the sensory experience.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Studying before bed can improve retention, as the brain continues to process information during sleep.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Writing practice exams for yourself is an effective way to prepare for actual tests or exams.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Explaining concepts out loud in your own words can reinforce learning and highlight areas of weakness.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Creating a designated study space can signal to your brain that it's time to focus and can improve study habits.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Taking breaks to stretch or do light physical activity can increase blood flow to the brain and improve cognitive function.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Using different colored pens for notes can help organize information and make it easier to recall.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Studies have shown that moderate caffeine consumption can enhance alertness and cognitive performance.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Incorporating humor into your study sessions can make learning more enjoyable and memorable.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Taking handwritten notes during lectures can lead to better understanding and retention compared to typing notes on a laptop.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Discussing and debating topics with peers can deepen understanding and provide new perspectives.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Creating mind maps or concept maps can help visualize relationships between ideas and aid in understanding complex concepts.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Studies suggest that getting enough sleep is crucial for optimal cognitive function, memory consolidation, and learning.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Breaking down large tasks into smaller, manageable chunks can reduce overwhelm and improve productivity.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Practicing meditation or mindfulness techniques can reduce stress and improve focus during study sessions.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Using online resources such as educational videos and interactive quizzes can supplement traditional study methods and enhance learning.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);
    funFactsList.add(TypewriterAnimatedText("Rewarding yourself with small treats or breaks after completing study goals can provide motivation and reinforce positive study habits.", speed: defaultWriterSpeed, curve: Curves.decelerate,),);



    funFactsList.shuffle();
    stopwatch.stop();
    print('Function Execution Time : ${stopwatch.elapsedMilliseconds}');
    return funFactsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Gap(MediaQuery.of(context).size.width*0.05),
            Text("Stoodee",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),

            Gap(20),
            Text("Did you know...",style: TextStyle(color: Colors.grey)),
            Gap(5),
            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width*0.9,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(1,1),
                    )
                  ]),
              child: FutureBuilder<List<AnimatedText>>(
                future: getRandomFactList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LinearProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Center(
                      child: AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: snapshot.data ?? [],
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

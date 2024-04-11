import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:stoodee/services/router/route_functions.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:stoodee/services/shared_prefs/shared_prefs.dart';



class IntroductionScreens extends StatefulWidget {
  const IntroductionScreens({super.key});

  @override
  State<IntroductionScreens> createState() => _IntroductionScreensState();
}

class _IntroductionScreensState extends State<IntroductionScreens> {

  late TextEditingController nameController;
  late TextEditingController taskController;
  late TextEditingController flashCardsController;


  @override
  void initState() {
    super.initState();
    nameController=TextEditingController();
    taskController=TextEditingController();
    flashCardsController=TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
          ClipPath(
            clipper: BackgroundWaveClipper(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 140,
              decoration: const BoxDecoration(
                  color: Colors.white,

                  gradient: LinearGradient(
                    colors: [primaryAppColor, secondaryAppColor],
                  )),
            ),
          ),
          Expanded(
            child: IntroductionScreen(
                pages: [
                  PageViewModel(
                    titleWidget: Align(
                      alignment: Alignment.centerLeft,
                      child: DefaultTextStyle(
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 60,
                            fontFamily: 'Roboto Mono',
                            height: 0.8,
                            letterSpacing: 1.4),
                        child: AnimatedTextKit(
                          repeatForever: false,
                          totalRepeatCount: 1,

                          animatedTexts:[
                            TyperAnimatedText("Stoodee",speed: Duration(milliseconds: 300))
                          ]
                        ),
                      ),
                    ),
                    bodyWidget: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Co to jest?',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 20,
                              fontFamily: 'Roboto'),
                          textAlign: TextAlign.left,
                        )),
                    image: Center(
                        child: Image.asset(
                          'lib/assets/BaseLogoSwan.png',
                          scale: 1,
                        )),
                    footer: Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                        bottom: MediaQuery.of(context).size.height*0.05
                      ),

                      child: const Text('Pomożemy ci w uczeniu 😎',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              fontFamily: 'Roboto',
                              height: 0.8,
                              letterSpacing: 0.8)),
                    ),
                    decoration: getPageDecoration1(),
                  ),
                  PageViewModel(
                    titleWidget: Stack(children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: SingleChildScrollView(
                          child: Text("ToDoPlaceHolder")
                        ),
                      ),
                      Positioned(
                          bottom: 16,
                          right: 16,
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.12,
                              height: MediaQuery.of(context).size.width * 0.12,
                              child: const FloatingActionButton(
                                  onPressed: testing_function,
                                  child: (Icon(
                                    Icons.add,
                                    color: primaryAppColor,
                                  ))))),
                    ]),
                    bodyWidget: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Lista zadań',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 50,
                            fontFamily: 'Roboto Mono',
                            height: 0.8,
                            letterSpacing: 1.4),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    footer: Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.05),
                      child: const Text('Usystematyzuj naukę',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              fontFamily: 'Roboto',
                              height: 0.8,
                              letterSpacing: 0.8)),
                    ),
                    decoration: getPageDecoration1(),
                  ),
                  PageViewModel(
                    titleWidget: Stack(children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: SingleChildScrollView(
                          child: Text("FlashcardsPlaceholder")
                        ),
                      ),
                      Positioned(
                          bottom: 16,
                          right: 16,
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.12,
                              height: MediaQuery.of(context).size.width * 0.12,
                              child: const FloatingActionButton(
                                  onPressed: testing_function,
                                  child: (Icon(
                                    Icons.add,
                                    color: primaryAppColor,
                                  ))))),
                    ]),
                    bodyWidget: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Fiszki',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 50,
                            fontFamily: 'Roboto Mono',
                            height: 0.8,
                            letterSpacing: 1.4),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    footer: Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.05),
                      child: const Text('Utrwalaj wiedzę',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              fontFamily: 'Roboto',
                              height: 0.8,
                              letterSpacing: 0.8)),
                    ),
                    decoration: getPageDecoration1(),
                  ),
                  PageViewModel(
                    title: 'Jeszcze tylko chwilka i możemy zaczynać',
                    bodyWidget: Container(
                      child: Column(
                        children: [
                          TextField(
                            textInputAction: TextInputAction.next,

                            autocorrect: false,
                            decoration: InputDecoration(
                              hintText: 'Name',
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: primaryAppColor),
                              ),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                            ),
                            controller: nameController,
                          ),
                          TextField(
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'todo',
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: primaryAppColor),
                              ),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                            ),
                            controller: taskController,
                          ),
                          TextField(
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'flashCard',
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: primaryAppColor),
                              ),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                            ),
                            controller: flashCardsController,
                          ),
                        ],
                      )
                    ),
                    image: Icon(Icons.settings,
                        color: primaryAppColor,
                        size: MediaQuery.of(context).size.width * 0.35), //120
                    decoration: getPageDecoration2(),


                  ),
                ],
                onDone: () async {
                  goRouterToLogin(context);
                  await SharedPrefs().setHasSeenIntro(value: true);

                },
                //ClampingScrollPhysics prevent the scroll offset from exceeding the bounds of the content.

                scrollPhysics: const ClampingScrollPhysics(),
                showDoneButton: true,
                showNextButton: false,
                showBackButton: false,
                back: const Icon(Icons.arrow_back),
                next: const Icon(Icons.forward),
                done: const Text('Done',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: primaryAppColor)),
                dotsDecorator: getDotsDecorator(),


            ),
          )
        ]));
  }

  //method to customise the page style
  PageDecoration getPageDecoration() {
    return const PageDecoration(

      titlePadding: EdgeInsets.only(top: 50),
      bodyTextStyle: TextStyle(color: Colors.black54, fontSize: 15),
      safeArea: 0,
    );
  }

  PageDecoration getPageDecoration1() {
    return PageDecoration(

      footerFlex: 0,
      footerPadding: const EdgeInsets.only(top: 10),
      titleTextStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 35,
        fontFamily: 'Roboto Mono',
        height: 0.8,
      ),
      titlePadding: const EdgeInsets.only(top: 0),
      imagePadding: const EdgeInsets.only(bottom: 0),
      bodyTextStyle: const TextStyle(
          color: Colors.black54, fontSize: 15, fontFamily: 'Roboto'),
      safeArea: MediaQuery.of(context).size.width * 0.1,
      imageFlex: 1,
    );
  }

  PageDecoration getPageDecoration2() {
    return PageDecoration(

      footerFlex: 0,
      footerPadding: const EdgeInsets.only(top: 10),
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: (MediaQuery.of(context).size.height) * 0.03,
        fontFamily: 'Roboto Mono',
        height: 0.8,
      ),
      titlePadding: const EdgeInsets.only(top: 0),
      imagePadding: const EdgeInsets.only(bottom: 10,top:0),

      bodyTextStyle: const TextStyle(
          color: Colors.black54, fontSize: 15, fontFamily: 'Roboto'),
      safeArea: MediaQuery.of(context).size.width * 0.1,
      imageFlex: 0,
    );
  }

  //method to customize the dots style
  DotsDecorator getDotsDecorator() {
    return const DotsDecorator(
      spacing: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      activeColor: primaryAppColor,
      color: Colors.grey,
      size: Size(12, 5),
      activeSize: Size(16, 9),
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
    );
  }
}

class BulletPointListItem extends StatelessWidget {
  final String text;

  const BulletPointListItem(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
        MainAxisAlignment.center, // Center align the children
        children: [
          const Icon(Icons.arrow_forward, size: 12),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}

class BackgroundWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    final p0 = size.height * 0.75;
    path.lineTo(0.0, p0);

    final controlPoint = Offset(size.width * 0.4, size.height);
    final endPoint = Offset(size.width, size.height / 2);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(BackgroundWaveClipper oldClipper) => oldClipper != this;
}

void testing_function() {
  print('pressed');
}

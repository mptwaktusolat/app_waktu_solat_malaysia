import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../CONSTANTS.dart';
import '../main.dart';
import 'Settings%20part/ThemePage.dart';
import 'ZoneChooser.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  var pageDecoration = const PageDecoration(
    titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
    bodyTextStyle: const TextStyle(fontSize: 19.0),
    descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    imagePadding: EdgeInsets.all(8.0),
  );

  bool _isDoneSetLocation = false;

  @override
  Widget build(BuildContext context) {
    List<PageViewModel> _pages = [
      PageViewModel(
          title: "Keep the location service on",
          body:
              "Turn on your GPS on so that the app can detect your location precisely",
          image: Image.asset(
            'assets/bam/Pin.png',
            width: 200,
          ),
          decoration: pageDecoration,
          footer: _isDoneSetLocation
              ? Text(
                  'Location set. You can change location anytime by tapping the location code at upper right corner.',
                  textAlign: TextAlign.center,
                )
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.teal),
                  onPressed: () async {
                    var res =
                        await LocationChooser.showLocationChooser(context);
                    if (res) {
                      setState(() {
                        _isDoneSetLocation = true;
                      });
                    }
                  },
                  child: Text(
                    'Set location',
                  ),
                )),
      PageViewModel(
        image: Image.asset(
          'assets/bam/Message.png',
          width: 200,
        ),
        bodyWidget: ThemesOption(),
        title: "Set your favourite theme",
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: "Alhamdulillah. All set",
        body:
            "Welcome abroad. Do explore and tweak the other features and settings as well.",
        image: Image.asset(
          'assets/bam/Tick.png',
          width: 200,
        ),
        decoration: pageDecoration,
      ),
    ];
    return IntroductionScreen(
        pages: _pages,
        color: Colors.teal,
        dotsDecorator: DotsDecorator(
          activeColor: Colors.teal,
          size: const Size.square(9.0),
          activeSize: const Size(18.0, 9.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
        next: const Text('Next', style: TextStyle(fontWeight: FontWeight.w600)),
        showSkipButton: true,
        skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
        curve: Curves.fastLinearToSlowEaseIn,
        onDone: () {
          GetStorage().write(kIsFirstRun, false);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (builder) => MyHomePage()));
        });
  }
}

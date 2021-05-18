import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:waktusolatmalaysia/locationUtil/LocationData.dart';
import 'package:waktusolatmalaysia/views/ZoneChooser.dart';

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
                    // LocationData.getCurrentLocation();

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
        title: "Set your favourite theme",
        body:
            "Download the MPT app and master the market with our mini-lesson.",
        image: Image.asset(
          'assets/bam/Message.png',
          width: 200,
        ),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: "You're good to go",
        body: "Alhamdulillah. All set.",
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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (builder) => Scaffold(
                body: Center(
                  child: Text(
                    'HOME',
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

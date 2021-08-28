import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../CONSTANTS.dart';
import '../main.dart';
import 'Settings part/NotificationSettingPage.dart';
import 'Settings%20part/ThemePage.dart';
import 'ZoneChooser.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  final _pageDecoration = const PageDecoration(
    titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
    bodyTextStyle: TextStyle(fontSize: 19.0),
    descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    imagePadding: EdgeInsets.all(8.0),
  );

  bool _isDoneSetLocation = false;
  AnimationController? _animController;
  MyNotificationType _type = MyNotificationType.noazan;

  @override
  void initState() {
    super.initState();
    _animController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    List<PageViewModel> _pages = [
      PageViewModel(
          title: "Set your location",
          body:
              "Keep your GPS on so that the app can detect your current location.",
          image: Image.asset(
            'assets/bam/Pin.png',
            width: 200,
          ),
          decoration: _pageDecoration,
          footer: _isDoneSetLocation
              ? const Text(
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
                  child: const Text(
                    'Set location',
                  ),
                )),
      PageViewModel(
        // image: Image.asset(
        //   'assets/bam/Message.png',
        //   width: 200,
        // ),
        image: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Builder(
            builder: (context) {
              bool _isDarkMode =
                  Theme.of(context).brightness == Brightness.dark;
              if (_isDarkMode) {
                _animController!.forward();
              } else {
                _animController!.reverse();
              }
              return AnimatedMoon(
                animationController: _animController,
                isDarkMode: _isDarkMode,
                width: 305,
              );
            },
          ),
        ),
        bodyWidget: const ThemesOption(),
        title: "Set your favourite theme",
        decoration: _pageDecoration,
      ),
      PageViewModel(
        image: Image.asset('assets/bam/Clock.png', width: 200),
        title: 'Select notification preferences',
        decoration: _pageDecoration,
        bodyWidget: ListView(shrinkWrap: true, children: [
          RadioListTile(
              value: MyNotificationType.noazan,
              groupValue: _type,
              title: const Text('Default notification sound'),
              onChanged: (MyNotificationType? type) {
                GetStorage().write(kNotificationType, type?.index);
                setState(() => _type = type!);
              }),
          RadioListTile(
              value: MyNotificationType.azan,
              groupValue: _type,
              title: const Text('Azan notification [NEW]'),
              onChanged: (MyNotificationType? type) {
                GetStorage().write(kNotificationType, type?.index);
                setState(() => _type = type!);
              }),
        ]),
      ),
      PageViewModel(
        title: "Alhamdulillah. All set",
        body:
            "Welcome abroad. Do explore other features and tweak other settings as well.",
        image: Image.asset(
          'assets/bam/Tick.png',
          width: 200,
        ),
        decoration: _pageDecoration,
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
        curve: Curves.fastLinearToSlowEaseIn,
        onDone: () {
          GetStorage().write(kIsFirstRun, false);
          GetStorage().write(kHaventIntroducedToNotifType, false);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (builder) => const MyHomePage()));
        });
  }
}

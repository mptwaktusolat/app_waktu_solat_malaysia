import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get_storage/get_storage.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../main.dart';
import '../providers/autostart_warning_provider.dart';
import '../providers/locale_provider.dart';
import '../utils/launch_url.dart';
import 'settings/notification_page_setting.dart';
import 'settings/theme_page.dart';
import '../components/shake_widget.dart';
import 'zone_chooser.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<IntroductionScreenState> _introScreenKey =
      GlobalKey<IntroductionScreenState>();
  final shakeKey = GlobalKey<ShakeWidgetState>();
  final _pageDecoration = const PageDecoration(
    titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
    bodyTextStyle: TextStyle(fontSize: 19.0),
    // descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    imagePadding: EdgeInsets.all(8.0),
  );

  bool _isDoneSetLocation = false;
  AnimationController? _animController;
  MyNotificationType _notificationType =
      MyNotificationType.values.elementAt(GetStorage().read(kNotificationType));

  @override
  void initState() {
    super.initState();
    _animController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  /// Check if platforms support AutoStart. (Excluusing Samsung devices)
  /// Related to https://github.com/mptwaktusolat/app_waktu_solat_malaysia/issues/89
  Future<bool> checkAutoStart() async {
    final autoStartAvailable = await isAutoStartAvailable;

    if (autoStartAvailable ?? false) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      final deviceBrand = androidInfo.brand;

      // skip triggering autostart banner for samsung devices because
      // there is no option to toggle autostart settings whatsoever
      if (deviceBrand.toLowerCase() == 'samsung') return false;
    }

    return autoStartAvailable ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final List<PageViewModel> pages = [
      PageViewModel(
        title: AppLocalizations.of(context)!.onboardingChooseLang,
        image: Image.asset(
          'assets/3d/chat-bubble-dynamic-color.png',
          width: 200,
        ),
        decoration: _pageDecoration,
        bodyWidget: Consumer<LocaleProvider>(builder: (_, value, __) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            RadioListTile(
                value: "en",
                groupValue: value.appLocale,
                title: const Text("English"),
                onChanged: (String? newValue) {
                  value.appLocale = newValue!;
                }),
            RadioListTile(
                value: "ms",
                groupValue: value.appLocale,
                title: const Text("Bahasa Malaysia"),
                onChanged: (String? newValue) {
                  GetStorage().write(kAppLanguage, newValue);
                  value.appLocale = newValue!;
                }),
          ]);
        }),
      ),
      PageViewModel(
          title: AppLocalizations.of(context)!.onboardingSetLocation,
          image: Image.asset('assets/3d/Pin.png', width: 200),
          decoration: _pageDecoration,
          bodyWidget: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                AppLocalizations.of(context)!.onboardingLocationDesc,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 71),
              _isDoneSetLocation
                  ? Text(
                      AppLocalizations.of(context)!.onboardingLocationToast,
                      textAlign: TextAlign.center,
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        final res =
                            await LocationChooser.showLocationChooser(context);
                        if (res) {
                          setState(() => _isDoneSetLocation = true);
                        }
                      },
                      child: Text(
                          AppLocalizations.of(context)!.onboardingLocationSet),
                    ),
            ],
          )),
      PageViewModel(
        image: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Builder(
            builder: (_) {
              final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
              if (isDarkMode) {
                _animController!.forward();
              } else {
                _animController!.reverse();
              }
              return AnimatedMoon(
                animationController: _animController,
                isDarkMode: isDarkMode,
                width: 305,
              );
            },
          ),
        ),
        bodyWidget: const ThemesOption(),
        title: AppLocalizations.of(context)!.onboardingThemeFav,
        decoration: _pageDecoration,
      ),
      PageViewModel(
        image: Image.asset('assets/3d/Clock.png', width: 200),
        title: AppLocalizations.of(context)!.onboardingNotifOption,
        decoration: _pageDecoration,
        bodyWidget: Column(mainAxisSize: MainAxisSize.min, children: [
          RadioListTile(
              value: MyNotificationType.noazan,
              groupValue: _notificationType,
              title: Text(AppLocalizations.of(context)!.onboardingNotifDefault),
              onChanged: (MyNotificationType? type) {
                GetStorage().write(kNotificationType, type?.index);
                setState(() => _notificationType = type!);
              }),
          RadioListTile(
              value: MyNotificationType.shortAzan,
              groupValue: _notificationType,
              title:
                  Text(AppLocalizations.of(context)!.onboardingNotifShortAzan),
              onChanged: (MyNotificationType? type) {
                GetStorage().write(kNotificationType, type?.index);
                setState(() => _notificationType = type!);
              }),
          RadioListTile(
              value: MyNotificationType.azan,
              groupValue: _notificationType,
              title: Text(AppLocalizations.of(context)!.onboardingNotifAzan),
              onChanged: (MyNotificationType? type) {
                GetStorage().write(kNotificationType, type?.index);
                setState(() => _notificationType = type!);
              }),
          FutureBuilder<bool>(
              future: checkAutoStart(),
              builder: (_, snapshot) {
                if (snapshot.hasData && snapshot.data!) {
                  // https://mobikul.com/shake-effect-in-flutter/
                  return ShakeWidget(
                    key: shakeKey,
                    shakeOffset: 10,
                    shakeCount: 5,
                    shakeDuration: const Duration(milliseconds: 200),
                    child: const _AutostartAdmonition(),
                  );
                }

                return const SizedBox.shrink();
              })
        ]),
      ),
      PageViewModel(
        title: AppLocalizations.of(context)!.onboardingFinish,
        body: AppLocalizations.of(context)!.onboardingFinishDesc,
        image: Image.asset(
          'assets/3d/Succes.png',
          width: 200,
        ),
        decoration: _pageDecoration,
      ),
    ];
    return IntroductionScreen(
        key: _introScreenKey,
        pages: pages,
        dotsDecorator: DotsDecorator(
          activeColor: Theme.of(context).colorScheme.primary,
          size: const Size.square(9.0),
          activeSize: const Size(18.0, 9.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        onChange: (value) async {
          // show notification permission dialog
          // when user reached the notification style chooser
          if (value == 3) {
            /// ask NotificationPermission
            final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
                FlutterLocalNotificationsPlugin();
            final perm1 = await flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                    AndroidFlutterLocalNotificationsPlugin>()
                ?.requestNotificationsPermission();
            // requst permission to schedule exact alarms (API 33+)
            final perm2 = await flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                    AndroidFlutterLocalNotificationsPlugin>()
                ?.requestExactAlarmsPermission();

            debugPrint('perm1: $perm1, perm2: $perm2');
          }
        },
        overrideNext: TextButton(
            child: Text(AppLocalizations.of(context)!.onboardingNext,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            onPressed: () async {
              final bool hasClick =
                  Provider.of<AutostartWarningProvider>(context, listen: false)
                      .hasClick;
              final bool isAutostartAvailable = await checkAutoStart();

              if (!isAutostartAvailable) {
                _introScreenKey.currentState?.next();
                return;
              }

              if (_introScreenKey.currentState!.controller.page!.toInt() == 3 &&
                  !hasClick) {
                // if the open setting button hasn't been clicked
                // shake the widgeta and wibrate a lil
                shakeKey.currentState?.shake();
                HapticFeedback.mediumImpact();
              } else {
                // using internal controller to go next
                _introScreenKey.currentState?.next();
              }
            }),
        done: Text(AppLocalizations.of(context)!.onboardingDone,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        doneSemantic: "Done button",
        nextSemantic: "Next button",
        curve: Curves.fastLinearToSlowEaseIn,
        onDone: () {
          // kIsFirstRun false setter are changed to Whats New Update Dialog
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (builder) => const MyHomePage()));
        });
  }
}

class _AutostartAdmonition extends StatelessWidget {
  const _AutostartAdmonition();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 2),
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
          color: Colors.amber.withOpacity(.3),
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          MarkdownBody(
            data: AppLocalizations.of(context)!.onboardingNotifAutostart(
                '$kAppSupportWebsite/docs/troubleshoot/notifications'),
            onTapLink: (_, href, __) {
              LaunchUrl.normalLaunchUrl(url: href!);
            },
          ),
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
                style: TextButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor:
                        Theme.of(context).textTheme.bodyLarge!.color),
                onPressed: () {
                  // to track the state of click
                  Provider.of<AutostartWarningProvider>(context, listen: false)
                      .hasClick = true;
                  // open auto start setting
                  getAutoStartPermission();
                },
                child: Text(AppLocalizations.of(context)!
                    .onboardingNotifAutostartSetting)),
          ),
        ],
      ),
    );
  }
}

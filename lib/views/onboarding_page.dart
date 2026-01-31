import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../features/onboarding/views/components/autostart_setting_dialog.dart';
import '../features/onboarding/views/components/notification_exact_alarm_permission_dialog.dart';
import '../features/onboarding/views/components/notification_permission_dialog.dart';
import '../features/prayer_zone/views/zone_chooser.dart';
import '../features/theme_options/views/theme_options.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../providers/locale_provider.dart';
import '../shared/components/animated_moon.dart';
import '../shared/constants/constants.dart';
import 'settings/notification_page_setting.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<IntroductionScreenState> _introScreenKey =
      GlobalKey<IntroductionScreenState>();
  final _pageDecoration = const PageDecoration(
    titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
    bodyTextStyle: TextStyle(fontSize: 19.0),
    // descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    imagePadding: EdgeInsets.all(8.0),
  );

  bool _isDoneSetLocation = false;
  bool _isDoneSetPermission = false;
  AnimationController? _animController;

  // default to azan type. As defined in initGetStorage() in main.dart
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

  /// Request necessary permissions for notification
  Future<void> _requestNecessaryNotificationPermissions() async {
    // Check notification status. Prior Android 13, the notification is grancted by default
    final isNotificationGranted = await Permission.notification.status;

    // check if Autostart is available on this device
    final bool isAutostartAvailable = await checkAutoStart();

    // check if schedule exact alarm permission is granted
    final isScheduleAlarmGranted = await Permission.scheduleExactAlarm.status;

    int permissionCount = 1; // to number the permission dialog
    if (isNotificationGranted != PermissionStatus.granted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return NotificationPermissionDialog(
            leadingCount: permissionCount.toString(),
            onGrantPermission: () async {
              final FlutterLocalNotificationsPlugin
                  flutterLocalNotificationsPlugin =
                  FlutterLocalNotificationsPlugin();
              final perm1 = await flutterLocalNotificationsPlugin
                  .resolvePlatformSpecificImplementation<
                      AndroidFlutterLocalNotificationsPlugin>()
                  ?.requestNotificationsPermission();
              debugPrint('Notification permission: $perm1');

              Navigator.pop(context);
            },
          );
        },
      );
    }
    permissionCount++;
    if (isScheduleAlarmGranted != PermissionStatus.granted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return NotificationExactAlarmPermissionDialog(
            leadingCount: permissionCount.toString(),
            onSkip: () {
              Navigator.of(context).pop();
            },
            onGrantPermission: () async {
              final FlutterLocalNotificationsPlugin
                  flutterLocalNotificationsPlugin =
                  FlutterLocalNotificationsPlugin();
              // requst permission to schedule exact alarms (API 33+)
              final perm2 = await flutterLocalNotificationsPlugin
                  .resolvePlatformSpecificImplementation<
                      AndroidFlutterLocalNotificationsPlugin>()
                  ?.requestExactAlarmsPermission();

              debugPrint('Schedule Exact Notification permission: $perm2');

              Navigator.pop(context);
            },
          );
        },
      );
      permissionCount++;
    }
    if (isAutostartAvailable) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AutostartSettingDialog(
            leadingCount: permissionCount.toString(),
            onSkip: () => Navigator.pop(context),
            onGrantPermission: () async {
              await getAutoStartPermission();

              Navigator.pop(context);
            },
          );
        },
      );
    }
    _isDoneSetPermission = true;
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
          return RadioGroup(
            onChanged: (String? newValue) {
              value.appLocale = newValue!;
            },
            groupValue: value.appLocale,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              RadioListTile(
                value: "en",
                title: const Text("English"),
              ),
              RadioListTile(
                value: "ms",
                title: const Text("Bahasa Malaysia"),
              ),
            ]),
          );
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
        ),
      ),
      PageViewModel(
        image: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Builder(
            builder: (_) {
              final bool isDarkMode =
                  Theme.of(context).brightness == Brightness.dark;
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
        bodyWidget: const ThemeOptions(),
        title: AppLocalizations.of(context)!.onboardingThemeFav,
        decoration: _pageDecoration,
      ),
      PageViewModel(
        image: Image.asset('assets/3d/Clock.png', width: 200),
        title: AppLocalizations.of(context)!.onboardingNotifOption,
        decoration: _pageDecoration,
        bodyWidget: RadioGroup(
          onChanged: (MyNotificationType? type) {
            GetStorage().write(kNotificationType, type?.index);
            setState(() => _notificationType = type!);
          },
          groupValue: _notificationType,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            RadioListTile(
              value: MyNotificationType.noazan,
              title: Text(AppLocalizations.of(context)!.onboardingNotifDefault),
            ),
            RadioListTile(
              value: MyNotificationType.shortAzan,
              title:
                  Text(AppLocalizations.of(context)!.onboardingNotifShortAzan),
            ),
            RadioListTile(
              value: MyNotificationType.azan,
              title: Text(AppLocalizations.of(context)!.onboardingNotifAzan),
            ),
          ]),
        ),
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
        // enable safe area at the bottom. https://github.com/mptwaktusolat/app_waktu_solat_malaysia/issues/258
        safeAreaList: [
          false,
          false,
          false,
          true
        ],
        key: _introScreenKey,
        pages: pages,
        dotsDecorator: DotsDecorator(
          activeColor: Theme.of(context).colorScheme.primary,
          size: const Size.square(9.0),
          activeSize: const Size(18.0, 9.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        overrideNext: (context, onNext) => TextButton(
              child: Text(AppLocalizations.of(context)!.onboardingNext,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              onPressed: () async {
                /// Request necessary permissions for notification when transitioning to page 3 to final page
                if (!_isDoneSetPermission &&
                    _introScreenKey.currentState!.controller.page!.toInt() ==
                        3) {
                  await _requestNecessaryNotificationPermissions();
                }
                onNext?.call();
              },
            ),
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

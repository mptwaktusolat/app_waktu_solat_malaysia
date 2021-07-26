import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:waktusolatmalaysia/utils/debug_toast.dart';
import 'CONSTANTS.dart';
import 'locationUtil/location_provider.dart';
import 'notificationUtil/notifications_helper.dart';
import 'utils/sharing_fab.dart';
import 'views/Settings%20part/ThemeController.dart';
import 'views/Settings%20part/settingsProvider.dart';
import 'views/appBody.dart';
import 'views/bottomAppBar.dart';
import 'views/onboarding_page.dart';

NotificationAppLaunchDetails notifLaunch;

void main() async {
  await GetStorage.init();

  final FlutterLocalNotificationsPlugin notifsPlugin =
      FlutterLocalNotificationsPlugin();
  await _configureLocalTimeZone();
  notifLaunch = await notifsPlugin.getNotificationAppLaunchDetails();
  await initNotifications(notifsPlugin);
  // requestIOSPermissions(notifsPlugin);

  await Firebase.initializeApp();
  initGetStorage();
  // readAllGetStorage();
  /// Increment app launch counter
  GetStorage().write(kAppLaunchCount, GetStorage().read(kAppLaunchCount) + 1);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  runApp(const MyApp());

  showReviewPrompt();
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  final _primaryColour = Colors.teal;

  @override
  Widget build(BuildContext context) {
    configureSelectNotificationSubject(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => ThemeController())
      ],
      child: Consumer<ThemeController>(
        builder: (context, value, child) {
          return MaterialApp(
            // debugShowCheckedModeBanner: false,
            title: 'MY Prayer Time', // will show in Android "RECENT" page.
            theme: ThemeData.light().copyWith(
              primaryColor: _primaryColour,
              bottomAppBarColor: Colors.teal.shade50,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              appBarTheme: AppBarTheme(
                  color: _primaryColour, brightness: Brightness.dark),
            ),
            darkTheme: ThemeData.dark().copyWith(
                primaryColor: _primaryColour,
                bottomAppBarColor: Colors.teal.withOpacity(0.4),
                visualDensity: VisualDensity.adaptivePlatformDensity,
                appBarTheme: AppBarTheme(color: _primaryColour.shade800)),
            themeMode: value.themeMode,
            home: GetStorage().read(kIsFirstRun)
                ? const OnboardingPage()
                : const MyHomePage(),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '🇲🇾 Prayer Time',
          style: GoogleFonts.balooTamma(),
        ),
        elevation: 0.0,
        centerTitle: true,
        toolbarHeight: 50,
      ),
      bottomNavigationBar: const MyBottomAppBar(),
      floatingActionButton: const ShareFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      body: const SingleChildScrollView(child: AppBody()),
    );
  }
}

void initGetStorage() {
  // init default settings
  GetStorage _get = GetStorage();
  _get.writeIfNull(kAppLaunchCount, 1);
  _get.writeIfNull(kIsFirstRun, true);
  _get.writeIfNull(kStoredGlobalIndex, 0);
  _get.writeIfNull(kStoredTimeIs12, true);
  _get.writeIfNull(kStoredShowOtherPrayerTime, false);
  _get.writeIfNull(kStoredShouldUpdateNotif, true);
  _get.writeIfNull(kStoredLastUpdateNotif, 0);
  _get.writeIfNull(kStoredNotificationLimit, false);
  _get.writeIfNull(kIsDebugMode, false);
  _get.writeIfNull(kForceUpdateNotif, false);
  _get.writeIfNull(kDiscoveredDeveloperOption, false);
  _get.writeIfNull(kSharingFormat, 0);
  _get.writeIfNull(kFontSize, 14.0);
  _get.writeIfNull(kHijriOffset, 0);
}

Future<void> _configureLocalTimeZone() async {
  // use for notification
  tz.initializeTimeZones();
  const String timeZoneName = 'Asia/Kuala_Lumpur';
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

void readAllGetStorage() {
  // print (almost) all GetStorage item to the console
  print("-----All GET STORAGE-----");
  GetStorage _get = GetStorage();
  print('kStoredFirstRun is ${_get.read(kIsFirstRun)}');
  print('kStoredGlobalIndex is ${_get.read(kStoredGlobalIndex)}');
  print('kStoredTimeIs12 is ${_get.read(kStoredTimeIs12)}');
  print(
      'kStoredShowOtherPrayerTime is ${_get.read(kStoredShowOtherPrayerTime)}');
  print('kStoredShouldUpdateNotif is ${_get.read(kStoredShouldUpdateNotif)}');
  print('kStoredLastUpdateNotif is ${_get.read(kStoredLastUpdateNotif)}');
  print('kStoredNotificationLimit is ${_get.read(kStoredNotificationLimit)}');
  print('kIsDebugMode is ${_get.read(kIsDebugMode)}');
  print('kForceUpdateNotif is ${_get.read(kForceUpdateNotif)}');
  print(
      'kDiscoveredDeveloperOption is ${_get.read(kDiscoveredDeveloperOption)}');
  print('-----------------------');
}

/// Show InAppReview if all conditions are met
void showReviewPrompt() async {
  final InAppReview inAppReview = InAppReview.instance;

  int _appLaunchCount = GetStorage().read(kAppLaunchCount);
  DebugToast.show(_appLaunchCount.toString(), force: true);

  if (_appLaunchCount == 10 && await inAppReview.isAvailable()) {
    await Future.delayed(const Duration(seconds: 2));
    inAppReview.requestReview();
  }
}

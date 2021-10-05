import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:waktusolatmalaysia/locationUtil/locationDatabase.dart';
import 'package:waktusolatmalaysia/providers/updater_provider.dart';
import 'views/Settings%20part/NotificationSettingPage.dart';
import 'CONSTANTS.dart';
import 'providers/location_provider.dart';
import 'notificationUtil/notifications_helper.dart';
import 'providers/ThemeController.dart';
import 'providers/settingsProvider.dart';
import 'utils/sharing_fab.dart';
import 'views/appBody.dart';
import 'views/bottomAppBar.dart';
import 'views/onboarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();

  await _configureLocalTimeZone();
  await initNotifications();
  // requestIOSPermissions(notifsPlugin);

  initGetStorage();
  // readAllGetStorage();

  /// Increment app launch counter
  GetStorage().write(kAppLaunchCount, GetStorage().read(kAppLaunchCount) + 1);

  migrateLocationIndexToLocationCode();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  runApp(const MyApp());

  showReviewPrompt();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  final _primaryColour = Colors.teal;

  @override
  Widget build(BuildContext context) {
    configureSelectNotificationSubject();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => UpdaterProvider()),
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
                color: _primaryColour,
                // ssytem overlay style
              ),
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
  const MyHomePage({Key? key}) : super(key: key);

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

void migrateLocationIndexToLocationCode() {
  //TODO: Remove migration is no longer needed
  var storedIndex = GetStorage().read(kStoredGlobalIndex);
  if (storedIndex != null) {
    GetStorage().write(
        kStoredLocationJakimCode, LocationDatabase.getJakimCode(storedIndex));
    GetStorage().remove(
        kStoredGlobalIndex); // delete this key so it will never be used again
  }
}

void initGetStorage() {
  // init default settings
  GetStorage _get = GetStorage();
  _get.writeIfNull(kNotificationType, MyNotificationType.azan.index);
  _get.writeIfNull(kShowNotifPrompt, true);
  _get.writeIfNull(kAppLaunchCount, 0);
  _get.writeIfNull(kIsFirstRun, true);
  _get.writeIfNull(kStoredLocationJakimCode, 'WLY01');
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
  _get.writeIfNull(kHijriOffset, -1);
}

Future<void> _configureLocalTimeZone() async {
  // use for notification
  tz.initializeTimeZones();
  const String timeZoneName = 'Asia/Kuala_Lumpur';
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

// ignore_for_file: avoid_print
void readAllGetStorage() {
  // print (almost) all GetStorage item to the console
  print("-----All GET STORAGE-----\n");

  var keys = GetStorage().getKeys();

  for (var key in keys) {
    print('$key ${GetStorage().read(key)}');
  }
  print('-----------------------\n');
}

/// Show InAppReview if all conditions are met
void showReviewPrompt() async {
  final InAppReview inAppReview = InAppReview.instance;

  int _appLaunchCount = GetStorage().read(kAppLaunchCount);

  if (_appLaunchCount == 10 && await inAppReview.isAvailable()) {
    await Future.delayed(const Duration(seconds: 2));
    inAppReview.requestReview();
  }
}

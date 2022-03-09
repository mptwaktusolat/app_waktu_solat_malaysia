import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'CONSTANTS.dart';
import 'notificationUtil/notifications_helper.dart';
import 'providers/ThemeController.dart';
import 'providers/locale_provider.dart';
import 'providers/location_provider.dart';
import 'providers/settingsProvider.dart';
import 'providers/timetable_provider.dart';
import 'providers/updater_provider.dart';
import 'utils/sharing_fab.dart';
import 'views/Settings%20part/NotificationSettingPage.dart';
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

  LicenseRegistry.addLicense(() async* {
    // This adds SIL license to the registrar
    final license = await rootBundle.loadString('assets/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  /// Increment app launch counter
  GetStorage().write(kAppLaunchCount, GetStorage().read(kAppLaunchCount) + 1);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  runApp(const MyApp());

  _showReviewPrompt();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  final _primaryColour = Colors.teal;
  // TODO: Add another colour

  @override
  Widget build(BuildContext context) {
    configureSelectNotificationSubject();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UpdaterProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => TimetableProvider()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (_, themeValue, localeValue, __) {
          return MaterialApp(
            onGenerateTitle: (context) =>
                AppLocalizations.of(context)!.appTitle,
            theme: ThemeData.light().copyWith(
              primaryColor: _primaryColour,
              bottomAppBarColor: Colors.teal.shade50,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              appBarTheme: AppBarTheme(
                color: _primaryColour,
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
                primaryColor: _primaryColour,
                bottomAppBarColor: Colors.teal.withOpacity(0.4),
                visualDensity: VisualDensity.adaptivePlatformDensity,
                appBarTheme: AppBarTheme(color: _primaryColour.shade800)),
            themeMode: themeValue.themeMode,
            // Material 3 ?
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale(localeValue.appLocale),
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
          AppLocalizations.of(context)!.appbarTitle,
          style: GoogleFonts.balooTamma(),
        ),
        elevation: 0.0,
        centerTitle: true,
        toolbarHeight: 50,
      ),
      bottomNavigationBar: const MyBottomAppBar(),
      floatingActionButton: const ShareFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      body: const SingleChildScrollView(
        child: AppBody(),
      ),
    );
  }
}

void initGetStorage() {
  // init default settings
  GetStorage _get = GetStorage();
  _get.writeIfNull(kHasShowQiblaWarning, false);
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
  // make default to default locale
  var _localeName = Platform.localeName.split('_').first;
  _get.writeIfNull(kAppLanguage, _localeName == "ms" ? _localeName : "en");
  _get.writeIfNull(kAppTheme, ThemeMode.light.name);
}

Future<void> _configureLocalTimeZone() async {
  // use for notification
  tz.initializeTimeZones();
  const String timeZoneName = 'Asia/Kuala_Lumpur';
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

void _readAllGetStorage() {
  // print (almost) all GetStorage item to the console
  print("-----All GET STORAGE-----\n");

  var keys = GetStorage().getKeys();

  for (var key in keys) {
    print('$key ${GetStorage().read(key)}');
  }
  print('-----------------------\n');
}

/// Show InAppReview if all conditions are met
void _showReviewPrompt() async {
  final InAppReview inAppReview = InAppReview.instance;

  int _appLaunchCount = GetStorage().read(kAppLaunchCount);

  if (_appLaunchCount == 10 && await inAppReview.isAvailable()) {
    await Future.delayed(const Duration(seconds: 2));
    inAppReview.requestReview();
  }
}

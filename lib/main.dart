import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
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
import 'package:quick_actions/quick_actions.dart';
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
import 'views/Qibla part/qibla.dart';
import 'views/Qibla part/qibla_warn.dart';
import 'views/Settings%20part/NotificationSettingPage.dart';
import 'views/appBody.dart';
import 'views/bottomAppBar.dart';
import 'views/onboarding_page.dart';
import 'views/prayer_full_table.dart';
import 'views/tasbih.dart';

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

  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());

  _showReviewPrompt();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  final _primaryColour = Colors.teal;
  // TODO: Add another colour

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

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
            navigatorObservers: <NavigatorObserver>[observer],
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
    configureQuickAction(context);
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        title: Text(AppLocalizations.of(context)!.appbarTitle,
            style: GoogleFonts.balooTamma2(fontWeight: FontWeight.bold)),
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
  GetStorage get = GetStorage();
  get.writeIfNull(kHasShowQiblaWarning, false);
  get.writeIfNull(kNotificationType, MyNotificationType.azan.index);
  get.writeIfNull(kShowNotifPrompt, true);
  get.writeIfNull(kAppLaunchCount, 0);
  get.writeIfNull(kIsFirstRun, true);
  get.writeIfNull(kStoredLocationJakimCode, 'WLY01');
  get.writeIfNull(kStoredTimeIs12, true);
  get.writeIfNull(kStoredShowOtherPrayerTime, false);
  get.writeIfNull(kShouldUpdateNotif, true);
  get.writeIfNull(kStoredLastUpdateNotif, 0);
  get.writeIfNull(kStoredNotificationLimit, false);
  get.writeIfNull(kIsDebugMode, false);
  get.writeIfNull(kDiscoveredDeveloperOption, false);
  get.writeIfNull(kSharingFormat, 0);
  get.writeIfNull(kFontSize, 14.0);
  // make default to default locale
  var localeName = Platform.localeName.split('_').first;
  get.writeIfNull(kAppLanguage, localeName == "ms" ? localeName : "en");
  get.writeIfNull(kAppTheme, ThemeMode.light.name);
}

/// Laucher icon shortcuts
void configureQuickAction(BuildContext context) {
  const QuickActions quickActions = QuickActions();
  quickActions.initialize((shortcutType) {
    switch (shortcutType) {
      case 'action_qibla':
        Navigator.push(
          context,
          MaterialPageRoute(
            settings: const RouteSettings(name: 'Qibla'),
            builder: (_) => GetStorage().read(kHasShowQiblaWarning)
                ? const Qibla()
                : const QiblaWarn(),
          ),
        );
        break;
      case 'action_tasbih':
        Navigator.push(
          context,
          MaterialPageRoute(
            settings: const RouteSettings(name: 'Tasbih'),
            builder: (_) => const Tasbih(),
          ),
        );
        break;
      case 'action_timetable':
        Navigator.push(
          context,
          MaterialPageRoute(
            settings: const RouteSettings(name: 'Full timetable'),
            builder: (context) => PrayerFullTable(),
          ),
        );
        break;
      default:
        print('Unknown shortcut');
    }
  });

  quickActions.setShortcutItems(<ShortcutItem>[
    ShortcutItem(
        type: 'action_qibla',
        localizedTitle: AppLocalizations.of(context)!.qiblaTitle,
        icon: 'ic_shortcut_kaaba'),
    ShortcutItem(
        type: 'action_timetable',
        localizedTitle: AppLocalizations.of(context)!.menuTimetableTooltip,
        icon: 'ic_shortcut_calendar'),
    const ShortcutItem(
        type: 'action_tasbih',
        localizedTitle: 'Tasbih',
        icon: 'ic_shortcut_tasbih')
  ]);
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

  int appLaunchCount = GetStorage().read(kAppLaunchCount);

  if (appLaunchCount == 10 && await inAppReview.isAvailable()) {
    await Future.delayed(const Duration(seconds: 2));
    inAppReview.requestReview();
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    // allow e-solat jakim to bypass
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) =>
              host == 'www.e-solat.gov.my';
  }
}

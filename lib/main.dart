import 'dart:convert';
import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hotspot/hotspot.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'constants.dart';
import 'env.dart';
import 'features/kompas_kiblat/views/qibla_disclaimer_page.dart';
import 'features/kompas_kiblat/views/qibla_page.dart';
import 'firebase_options.dart';
import 'location_utils/location_database.dart';
import 'models/jakim_zones.dart';
import 'notificationUtil/notifications_helper.dart';
import 'providers/locale_provider.dart';
import 'providers/location_provider.dart';
import 'providers/setting_provider.dart';
import 'providers/theme_controller.dart';
import 'providers/timetable_provider.dart';
import 'providers/updater_provider.dart';
import 'utils/sharing_fab.dart';
import 'views/app_body.dart';
import 'views/my_bottom_app_bar.dart';
import 'views/onboarding_page.dart';
import 'views/prayer_full_table.dart';
import 'views/settings/notification_page_setting.dart';
import 'views/tasbih.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MobileAds.instance.initialize();

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Disable analytics & crashlytics when in debug mode
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(!kDebugMode);

  await _configureLocalTimeZone();
  await initNotifications();

  initGetStorage();
  await _initializeJakimZoneData();

  LicenseRegistry.addLicense(() async* {
    // This adds SIL license to the registrar
    final license = await rootBundle.loadString('assets/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  /// Increment app launch counter
  GetStorage().write(kAppLaunchCount, GetStorage().read(kAppLaunchCount) + 1);

  if (kDebugMode) {
    HttpOverrides.global = MyHttpOverrides();
  }

  runApp(const MyApp());

  _showReviewPrompt();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // default colour seed for devices that didn't support dynamic colour
  final _primaryColour = Colors.teal;

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
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
          return DynamicColorBuilder(
              builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
            return MaterialApp(
              onGenerateTitle: (context) =>
                  AppLocalizations.of(context)!.appTitle,
              navigatorObservers: <NavigatorObserver>[observer],
              theme: ThemeData(
                colorScheme: lightDynamic ??
                    ColorScheme.fromSeed(seedColor: _primaryColour),
                useMaterial3: true,
              ),
              darkTheme: ThemeData.dark().copyWith(
                colorScheme: darkDynamic ??
                    ColorScheme.fromSeed(
                      seedColor: _primaryColour,
                      brightness: Brightness.dark,
                    ),
              ),
              themeMode: themeValue.themeMode,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: Locale(localeValue.appLocale),
              home: GetStorage().read(kIsFirstRun)
                  ? const OnboardingPage()
                  : const MyHomePage(),
            );
          });
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    _configureQuickAction(context);
    return HotspotProvider(
      actionBuilder: (context, controller) {
        return HotspotActionBuilder(
          controller,
          doneText: AppLocalizations.of(context)!.coachmarkDone,
          nextText: AppLocalizations.of(context)!.coachmarkNext,
          previousText: AppLocalizations.of(context)!.coachmarkPrevious,
          endText: AppLocalizations.of(context)!.coachmarkEnd,
        );
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          title: Text(AppLocalizations.of(context)!.appbarTitle,
              style: GoogleFonts.balooTamma2(fontWeight: FontWeight.bold)),
          elevation: 0.0,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.background,
          centerTitle: true,
          toolbarHeight: 50,
        ),
        // known issue that causes white line appear between appbar and widget below
        // https://github.com/flutter/flutter/issues/14288
        bottomNavigationBar: const MyBottomAppBar(),
        floatingActionButton: const ShareFAB(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        body: const SingleChildScrollView(
          child: AppBody(),
        ),
      ),
    );
  }
}

void initGetStorage() {
  // init default settings
  final GetStorage get = GetStorage();
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
  get.writeIfNull(kFontSize, 16.0);
  // make default to default locale
  final localeName = Platform.localeName.split('_').first;
  get.writeIfNull(kAppLanguage, localeName == "ms" ? "ms" : "en");
  get.writeIfNull(kAppTheme, ThemeMode.light.name);
  get.writeIfNull(kNotificationSheetKeepOff, false);
}

/// Launcher icon shortcuts
void _configureQuickAction(BuildContext context) {
  const QuickActions quickActions = QuickActions();
  quickActions.initialize((shortcutType) {
    switch (shortcutType) {
      case 'action_qibla':
        Navigator.push(
          context,
          MaterialPageRoute(
            settings: const RouteSettings(name: 'Qibla'),
            builder: (_) => GetStorage().read(kHasShowQiblaWarning)
                ? const QiblaPage()
                : const QiblaDisclaimerPage(),
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

Future _initializeJakimZoneData() async {
  final String data = await rootBundle.loadString('assets/json/zones.json');
  final List<dynamic> jsonDecoded = json.decode(data);
  LocationDatabase.allLocation =
      List.from(jsonDecoded.map((e) => JakimZones.fromJson(e)));
}

/// Show InAppReview if all conditions are met
void _showReviewPrompt() async {
  final InAppReview inAppReview = InAppReview.instance;

  final int appLaunchCount = GetStorage().read(kAppLaunchCount);

  if (appLaunchCount == 10 && await inAppReview.isAvailable()) {
    await Future.delayed(const Duration(seconds: 2));
    inAppReview.requestReview();
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    // allow mpt-server to bypass when there is error certificate expired
    // happened in Android 5 (emulator), not happens in recent Android versions
    return super.createHttpClient(context)
      ..badCertificateCallback = (_, String host, __) => host == envApiBaseHost;
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../constants/constants.dart';
import '../../firebase_options.dart';
import '../../location_utils/location_database.dart';
import '../../notificationUtil/notifications_helper.dart';
import '../models/jakim_zones.dart';
import 'app_launch_counter.dart';
import '../../views/settings/notification_page_setting.dart';

class StartupRoutine {
  static Future<void> initialize() async {
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

    await GetStorage.init();
    _initGetStorageData();

    await _initializeJakimZoneData();

    _registerLicenses();
  }

  /// Configure local timezone for notifications
  static Future<void> _configureLocalTimeZone() async {
    // use for notification
    tz.initializeTimeZones();
    const String timeZoneName = 'Asia/Kuala_Lumpur';
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  /// Initialize GetStorage with default values
  static void _initGetStorageData() {
    // init default settings
    final GetStorage get = GetStorage();
    get.writeIfNull(kHasShowQiblaWarning, false);
    get.writeIfNull(kNotificationType, MyNotificationType.azan.index);
    get.writeIfNull(kShowNotifPrompt, true);
    get.writeIfNull(kAppLaunchCount, 0);
    get.writeIfNull(kIsFirstRun, true);
    get.writeIfNull(kStoredLocationJakimCode, 'WLY01');
    get.writeIfNull(kStoredTimeIs12, true);
    // Many people doesn't realize they have the ability to toggle Imsak, Syuruk,
    // Dhuha display, so we make them shown by default. See issue: https://github.com/mptwaktusolat/app_waktu_solat_malaysia/issues/171.
    get.writeIfNull(kStoredShowOtherPrayerTime, true);
    get.writeIfNull(kShouldUpdateNotif, true);
    get.writeIfNull(kStoredLastUpdateNotif, 0);
    get.writeIfNull(kStoredNotificationLimit, false);
    get.writeIfNull(kIsDebugMode, false);
    get.writeIfNull(kDiscoveredDeveloperOption, false);
    get.writeIfNull(kFontSize, 16.0);
    // make default to default locale
    final localeName = Platform.localeName.split('_').first;
    get.writeIfNull(kAppLanguage, localeName == "ms" ? "ms" : "en");
    get.writeIfNull(kAppTheme, ThemeMode.light.name);
    get.writeIfNull(kNotificationSheetKeepOff, false);
  }

  /// Load Jakim zone data from assets to memory
  static Future<void> _initializeJakimZoneData() async {
    final String data = await rootBundle.loadString('assets/json/zones.json');
    final List<dynamic> jsonDecoded = json.decode(data);
    LocationDatabase.allLocation =
        List.from(jsonDecoded.map((e) => JakimZones.fromJson(e)));
  }

  /// Register licenses for fonts
  static void _registerLicenses() {
    LicenseRegistry.addLicense(() async* {
      // This adds SIL license to the registrar
      final license = await rootBundle.loadString('assets/OFL.txt');
      yield LicenseEntryWithLineBreaks(['google_fonts'], license);
    });
  }

  /// Show InAppReview if all conditions are met
  static Future<void> showReviewPrompt() async {
    final InAppReview inAppReview = InAppReview.instance;

    final int appLaunchCount = AppLaunchCounter.getAppLaunches();

    if (appLaunchCount == 10 && await inAppReview.isAvailable()) {
      await Future.delayed(const Duration(seconds: 2));
      inAppReview.requestReview();
    }
  }
}

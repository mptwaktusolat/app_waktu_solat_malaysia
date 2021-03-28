import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:waktusolatmalaysia/utils/sharing_fab.dart';
import 'CONSTANTS.dart';
import 'utils/LocationData.dart';
import 'utils/notifications_helper.dart';
import 'views/Settings%20part/ThemeController.dart';
import 'views/Settings%20part/settingsProvider.dart';
import 'views/appBody.dart';
import 'views/bottomAppBar.dart';

NotificationAppLaunchDetails notifLaunch;
final FlutterLocalNotificationsPlugin notifsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  await GetStorage.init();

  LocationData.getCurrentLocation();
  await _configureLocalTimeZone();

  notifLaunch = await notifsPlugin.getNotificationAppLaunchDetails();
  await initNotifications(notifsPlugin);
  // requestIOSPermissions(notifsPlugin);

  await Firebase.initializeApp();
  initGetStorage();

  // readAllGetStorage();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  Get.lazyPut(() => ThemeController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _primaryColour = Colors.teal;

  @override
  Widget build(BuildContext context) {
    configureSelectNotificationSubject(context);
    ThemeController.to.getThemeModeFromPreferences();
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SettingProvider())],
      child: GetMaterialApp(
        // debugShowCheckedModeBanner: false,
        title: 'My Prayer Time',
        theme: ThemeData.light().copyWith(
          primaryColor: _primaryColour,
          bottomAppBarColor: Colors.teal.shade50,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme:
              AppBarTheme(color: _primaryColour, brightness: Brightness.dark),
        ),
        darkTheme: ThemeData.dark().copyWith(
            primaryColor: _primaryColour,
            bottomAppBarColor: Colors.teal.withOpacity(0.4),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: AppBarTheme(color: _primaryColour.shade800)),
        themeMode: ThemeController.to.themeMode,
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
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
      bottomNavigationBar: MyBottomAppBar(),
      floatingActionButton: ShareFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: SingleChildScrollView(child: AppBody()),
    );
  }
}

void initGetStorage() {
  GetStorage _getStorage = GetStorage();
  _getStorage.writeIfNull(kStoredFirstRun, true);
  _getStorage.writeIfNull(kStoredGlobalIndex, 0);
  _getStorage.writeIfNull(kStoredTimeIs12, true);
  _getStorage.writeIfNull(kStoredShowOtherPrayerTime, false);
  _getStorage.writeIfNull(kStoredShouldUpdateNotif, true);
  _getStorage.writeIfNull(kStoredLastUpdateNotif, 0);
  _getStorage.writeIfNull(kStoredNotificationLimit, false);
  _getStorage.writeIfNull(kIsDebugMode, false);
  _getStorage.writeIfNull(kForceUpdateNotif, false);
  _getStorage.writeIfNull(kDiscoveredDeveloperOption, false);
  _getStorage.writeIfNull(kSharingFormat, 0);
  _getStorage.writeIfNull(kFontSize, 14.0);
  _getStorage.writeIfNull(kHijriOffset, -1);
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = 'Asia/Kuala_Lumpur';
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

void readAllGetStorage() {
  print("-----All GET STORAGE-----");
  print('kStoredFirstRun is ${GetStorage().read(kStoredFirstRun)}');
  print('kStoredGlobalIndex is ${GetStorage().read(kStoredGlobalIndex)}');
  print('kStoredTimeIs12 is ${GetStorage().read(kStoredTimeIs12)}');
  print(
      'kStoredShowOtherPrayerTime is ${GetStorage().read(kStoredShowOtherPrayerTime)}');
  print(
      'kStoredShouldUpdateNotif is ${GetStorage().read(kStoredShouldUpdateNotif)}');
  print(
      'kStoredLastUpdateNotif is ${GetStorage().read(kStoredLastUpdateNotif)}');
  print(
      'kStoredNotificationLimit is ${GetStorage().read(kStoredNotificationLimit)}');
  print('kIsDebugMode is ${GetStorage().read(kIsDebugMode)}');
  print('kForceUpdateNotif is ${GetStorage().read(kForceUpdateNotif)}');
  print(
      'kDiscoveredDeveloperOption is ${GetStorage().read(kDiscoveredDeveloperOption)}');
  print('-----------------------');
}

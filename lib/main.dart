import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'CONSTANTS.dart';
import 'utils/LocationData.dart';
import 'utils/cachedPrayerData.dart';
import 'utils/copyAndShare.dart';
import 'utils/notifications_helper.dart';
import 'views/Settings%20part/ThemeController.dart';
import 'views/Settings%20part/settingsProvider.dart';
import 'views/appBody.dart';
import 'views/bottomAppBar.dart';

NotificationAppLaunchDetails notifLaunch;
final FlutterLocalNotificationsPlugin notifsPlugin =
    FlutterLocalNotificationsPlugin();

//TODO: Global debug mode in Setting

void main() async {
  await GetStorage.init();

  LocationData.getCurrentLocation();
  await _configureLocalTimeZone();

  notifLaunch = await notifsPlugin.getNotificationAppLaunchDetails();
  await initNotifications(notifsPlugin);
  requestIOSPermissions(notifsPlugin);

  initGetStorage();

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
          kIsWeb ? '🇲🇾 Prayer Time (BETA)' : '🇲🇾 Prayer Time',
          style: GoogleFonts.balooTamma(),
        ),
        elevation: 0.0,
        centerTitle: true,
        toolbarHeight: 50,
      ),
      bottomNavigationBar: MyBottomAppBar(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.share),
          mini: true,
          tooltip: 'Share',
          onPressed: () {
            print(CachedPrayerTimeData.allPrayerTime().toString());
            Share.share(CopyAndShare.getMessage());
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: SingleChildScrollView(child: AppBody()),
    );
  }
}

void initGetStorage() {
  GetStorage().writeIfNull(kStoredFirstRun, true);
  GetStorage().writeIfNull(kStoredTimeIs12, true);
  GetStorage().writeIfNull(kStoredShowOtherPrayerTime, false);
  GetStorage().writeIfNull(kStoredShouldUpdateNotif, true);
  GetStorage().writeIfNull(kStoredLastUpdateNotif, 0);
  GetStorage().writeIfNull(kStoredNotificationLimit, false);
  GetStorage().writeInMemory(kIsDebugMode, false);
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = 'Asia/Kuala_Lumpur';
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

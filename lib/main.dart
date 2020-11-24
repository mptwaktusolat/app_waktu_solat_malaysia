import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:waktusolatmalaysia/utils/LocationData.dart';
import 'package:waktusolatmalaysia/utils/cachedPrayerData.dart';
import 'package:waktusolatmalaysia/utils/copyAndShare.dart';
import 'package:waktusolatmalaysia/utils/notifications_helper.dart';
import 'package:waktusolatmalaysia/views/Settings%20part/ThemeController.dart';
import 'package:waktusolatmalaysia/views/Settings%20part/settingsProvider.dart';
import 'package:waktusolatmalaysia/views/appBody.dart';
import 'package:waktusolatmalaysia/views/bottomAppBar.dart';
import 'CONSTANTS.dart';

NotificationAppLaunchDetails notifLaunch;
final FlutterLocalNotificationsPlugin notifsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  await GetStorage.init();

  LocationData.getCurrentLocation();
  await _configureLocalTimeZone();

  notifLaunch = await notifsPlugin.getNotificationAppLaunchDetails();
  await initNotifications(notifsPlugin);
  requestIOSPermissions(notifsPlugin);

  initGetStorage();

  Get.lazyPut<ThemeController>(() => ThemeController());
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  var _primaryColour = Colors.teal;

  @override
  Widget build(BuildContext context) {
    ThemeController.to.getThemeModeFromPreferences();
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SettingProvider())],
      child: GetMaterialApp(
        title: 'My Prayer Time',
        theme: ThemeData.light().copyWith(
          primaryColor: _primaryColour,
          bottomAppBarColor: Colors.teal.shade50,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(color: _primaryColour),
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
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await platform.invokeMethod('getTimeZoneName');
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

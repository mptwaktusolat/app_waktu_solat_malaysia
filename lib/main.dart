import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'CONSTANTS.dart';
import 'utils/sharing_fab.dart';
import 'views/Settings%20part/ThemeController.dart';
import 'views/Settings%20part/settingsProvider.dart';
import 'views/appBody.dart';
import 'views/bottomAppBar.dart';

void main() async {
  await GetStorage.init();

  initGetStorage();

  Get.lazyPut(() => ThemeController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _primaryColour = Colors.teal;

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
      body: SingleChildScrollView(
        child: AppBody(),
      ),
    );
  }
}

void initGetStorage() {
  GetStorage().writeIfNull(kStoredFirstRun, true);
  GetStorage().writeIfNull(kStoredGlobalIndex, 0);
  GetStorage().writeIfNull(kStoredTimeIs12, true);
  GetStorage().writeIfNull(kStoredShowOtherPrayerTime, false);
  GetStorage().writeIfNull(kIsDebugMode, false);
  GetStorage().writeIfNull(kFontSize, 14.0);
}

void readAllGetStorage() {
  print("-----All GET STORAGE-----");
  print('kStoredFirstRun is ${GetStorage().read(kStoredFirstRun)}');
  print('kStoredGlobalIndex is ${GetStorage().read(kStoredGlobalIndex)}');
  print('kStoredTimeIs12 is ${GetStorage().read(kStoredTimeIs12)}');
  print(
      'kStoredShowOtherPrayerTime is ${GetStorage().read(kStoredShowOtherPrayerTime)}');
  print('kIsDebugMode is ${GetStorage().read(kIsDebugMode)}');
  print('-----------------------');
}

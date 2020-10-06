import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'package:waktusolatmalaysia/utils/LocationData.dart';
import 'package:waktusolatmalaysia/utils/copyAndShare.dart';
import 'package:waktusolatmalaysia/utils/restartWidget.dart';
import 'package:waktusolatmalaysia/views/Settings%20part/ThemeController.dart';
import 'package:waktusolatmalaysia/views/appBody.dart';
import 'package:waktusolatmalaysia/views/bottomAppBar.dart';
import 'CONSTANTS.dart';

void main() async {
  await GetStorage.init();
  LocationData.getCurrentLocation();
  GetStorage().writeIfNull(kStoredFirstRun, true);
  Get.lazyPut<ThemeController>(() => ThemeController());
  runApp(
    RestartWidget(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root
  @override
  Widget build(BuildContext context) {
    ThemeController.to.getThemeModeFromPreferences();
    return GetMaterialApp(
      title: 'My Prayer Time',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.teal,
        bottomAppBarColor: Colors.teal.shade50,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.teal,
        bottomAppBarColor: Colors.teal.shade900,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: ThemeController.to.themeMode,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final CopyAndShare copyAndShare = CopyAndShare();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade900,
        brightness: Brightness.dark,
        title: Text(
          '🇲🇾 Prayer Time',
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
            copyAndShare.updateMessage();
            Share.share(copyAndShare.getMessage());
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: SingleChildScrollView(child: AppBody()),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waktusolatmalaysia/utils/restartWidget.dart';
import 'package:waktusolatmalaysia/views/appBody.dart';
import 'package:waktusolatmalaysia/views/bottomAppBar.dart';

void main() {
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
    return MaterialApp(
      title: 'Malaysia Prayer Time 2020',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade900,
        brightness: Brightness.dark,
        title: Text(
          '🇲🇾 Prayer Time BETA',
          style: GoogleFonts.balooTamma(),
        ),
        elevation: 0.0,
        centerTitle: true,
        toolbarHeight: 50,
      ),
      bottomNavigationBar: MyBottomAppBar(),
      floatingActionButton: FloatingActionButton(
          //TODO: Disable temporarily
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.share),
          mini: true,
          tooltip: 'Share',
          onPressed: () {
            print('FAB pressed');
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: SingleChildScrollView(child: AppBody()),
    );
  }
}

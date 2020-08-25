import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:waktusolatmalaysia/GetPrayerTime.dart';
import 'package:waktusolatmalaysia/ZoneChooser.dart';
import 'package:waktusolatmalaysia/utils/sizeconfig.dart';
import 'package:hijri/hijri_calendar.dart';

void main() {
  runApp(RestartWidget(
    child: MyApp(),
  ));
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

        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.share),
        //     tooltip: 'Share prayer time',
        //     onPressed: () {
        //       print('button ditekan');
        //     },
        //   )
        // ],
      ),
      body: SingleChildScrollView(child: AppBody()),
    );
  }
}

class AppBody extends StatelessWidget {
  final _today = HijriCalendar.now();
  // final DateTime date = DateTime.now();
  final dayFormat = DateFormat('EEEE').format(DateTime.now());
  final dateFormat = DateFormat('dd MMMM yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight / 6,
            decoration: BoxDecoration(
              color: Colors.cyan.shade900,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40)),
            ),
            padding: EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(70),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    dayFormat,
                                    style: GoogleFonts.spartan(
                                        color: Colors.white),
                                  ),
                                  Text(
                                    _today.toFormat("dd MMMM yyyy"),
                                    style: GoogleFonts.acme(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  Text(
                                    dateFormat,
                                    style:
                                        TextStyle(color: Colors.teal.shade100),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.all(5.0),
                        padding: EdgeInsets.all(18.0),
                        child: LocationChooser(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.screenHeight / 69,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(SizeConfig.screenWidth / 10, 8.0,
                SizeConfig.screenWidth / 10, 8.0),
            child: GetPrayerTime(),
          ),
          SizedBox(
            height: SizeConfig.screenHeight / 45,
          )
        ],
      ),
    );
  }
}

class RestartWidget extends StatefulWidget {
  RestartWidget({this.child});
  final Widget child;
  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>().restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}

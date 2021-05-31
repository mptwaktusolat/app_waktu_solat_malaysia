import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../locationUtil/locationDatabase.dart';
import '../locationUtil/location_provider.dart';
import '../utils/sizeconfig.dart';
import 'GetPrayerTime.dart';
import 'Settings%20part/settingsProvider.dart';
import 'ZoneChooser.dart';

class AppBody extends StatelessWidget {
  final _dayFormat = DateFormat('EEEE').format(DateTime.now());
  final _dateFormat = DateFormat('dd MMM yyyy').format(DateTime.now());

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
              color: Theme.of(context).appBarTheme.color,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40)),
            ),
            padding: EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
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
                              child: Consumer<SettingProvider>(
                                builder: (context, setting, child) {
                                  var _hijriToday = HijriCalendar.fromDate(
                                      DateTime.now().add(
                                          Duration(days: setting.hijriOffset)));
                                  return Column(
                                    children: [
                                      Text(
                                        _dayFormat,
                                        style: GoogleFonts.spartan(
                                            color: Colors.white),
                                      ),
                                      AutoSizeText(
                                        _hijriToday.toFormat("dd MMMM yyyy"),
                                        style: GoogleFonts.acme(
                                            color: Colors.white, fontSize: 17),
                                        stepGranularity: 1,
                                      ),
                                      Text(
                                        _dateFormat,
                                        style: TextStyle(
                                            color: Colors.teal.shade100,
                                            fontSize: 12),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      // flex: 3,
                      child: Consumer<LocationProvider>(
                        builder: (context, value, child) {
                          String shortCode = LocationDatabase.getJakimCode(
                              value.currentLocationIndex);
                          return Container(
                            margin: EdgeInsets.all(5.0),
                            padding: EdgeInsets.all(18.0),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.all(-5.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: BorderSide(color: Colors.white),
                                ),
                              ),
                              onPressed: () {
                                LocationChooser.showLocationChooser(context);
                              },
                              onLongPress: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Currently set to ${LocationDatabase.getDaerah(value.currentLocationIndex)} in ${LocationDatabase.getNegeri(value.currentLocationIndex)}'),
                                    behavior: SnackBarBehavior.floating,
                                    action: SnackBarAction(
                                      label: 'Change',
                                      onPressed: () {
                                        LocationChooser.openLocationBottomSheet(
                                            context);
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FaIcon(FontAwesomeIcons.mapMarkerAlt,
                                      color: Colors.teal.shade50, size: 15),
                                  Text(
                                    '  ${shortCode.substring(0, 3).toUpperCase()}  ${shortCode.substring(3, 5)}',
                                    style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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

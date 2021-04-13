///This widget is rendered as Location button at header part.
///Also handle the location selection
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show Get, GetNavigation;
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart';
import 'package:waktusolatmalaysia/utils/location/locationDatabase.dart';
import 'package:waktusolatmalaysia/views/GetPrayerTime.dart';

int globalIndex;

LocationDatabase locationDatabase = LocationDatabase();

class LocationChooser extends StatefulWidget {
  LocationChooser({Key key}) : super(key: key);

  @override
  _LocationChooserState createState() => _LocationChooserState();
}

class _LocationChooserState extends State<LocationChooser> {
  @override
  void initState() {
    super.initState();
    globalIndex = GetStorage().read(kStoredGlobalIndex);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //if first run, then promote to change location
      if (GetStorage().read(kStoredFirstRun)) {
        GetStorage().write(kStoredFirstRun, false);
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content:
                Text('Use the blue button on the top to update your location'),
            duration: Duration(seconds: 7),
            action: SnackBarAction(
              label: 'Got it!',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    });

    var locationText = locationDatabase.getDaerah(globalIndex);

    void _updateUI() {
      showSnackbarLocationSaved(context);

      setState(() {
        locationText = locationDatabase.getDaerah(globalIndex);
      });
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.white),
        ),
        // padding: EdgeInsets.all(-5.0),
      ),
      onPressed: () => openLocationBottomSheet(context, _updateUI),
      onLongPress: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Currently set to ${locationDatabase.getDaerah(globalIndex)} in ${locationDatabase.getNegeri(globalIndex)}'),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Change',
              onPressed: () {
                print('Pressed change loc');
                openLocationBottomSheet(context, _updateUI);
              },
            ),
          ),
        );
      },
      child: Text(
        locationText,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

Future openLocationBottomSheet(BuildContext context, Function callback) async {
  print(globalIndex);
  await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.68,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(26.0),
                topRight: Radius.circular(26.0)),
            child: Container(
              color: Theme.of(context).canvasColor,
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: locationDatabase.getLocationDatabaseLength(),
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        GetStorage().write(kStoredGlobalIndex, index);
                        Navigator.pop(context,
                            index); //index param here will pass as selectedindex below
                      },
                      title: Text(locationDatabase.getDaerah(index)),
                      subtitle: Text(locationDatabase.getNegeri(index)),
                      trailing: locationBubble(
                          context, locationDatabase.getJakimCode(index)),
                      selected: globalIndex == index ? true : false,
                    );
                  },
                ),
              ),
            ),
          ),
        );
      }).then((selectedIndex) {
    /*
      SelectedIndex is location index coming from Navigator.pop()
      app should restart when index changed
      when user close bottom sheet without selecting location, selectedIndex simply return null 
      */
    print('selectedIndex is $selectedIndex and globalIndex is $globalIndex');
    if (selectedIndex != globalIndex) {
      if (selectedIndex != null) {
        globalIndex = selectedIndex;
        callback();
        GetPrayerTime.updateUI(selectedIndex);
      }
    }
  });
}

Widget locationBubble(BuildContext context, String shortCode) {
  return Container(
    padding: EdgeInsets.all(4.0),
    decoration: BoxDecoration(
      border: Border.all(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white),
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Text(
      shortCode,
    ),
  );
}

void showSnackbarLocationSaved(BuildContext context) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 2500),
        content: Row(
          children: [
            Icon(
              Icons.pin_drop_rounded,
              color: Get.isDarkMode ? Colors.black87 : Colors.white70,
            ),
            SizedBox(
              width: 10,
            ),
            Text('Updated and saved'),
          ],
        ),
      ),
    );

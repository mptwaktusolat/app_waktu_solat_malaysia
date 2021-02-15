import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:waktusolatmalaysia/utils/launchUrl.dart';
import 'package:waktusolatmalaysia/views/Qibla%20part/qibla_compass.dart';

class Qibla extends StatefulWidget {
  @override
  _QiblaState createState() => _QiblaState();
}

class _QiblaState extends State<Qibla> {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Qibla Compass'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _deviceSupport,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );

          if (snapshot.hasError)
            return Center(
              child: Text('Error: ${snapshot.error.toString()}'),
            );
          if (snapshot.hasData)
            return QiblaCompass();
          else
            return Container(
              child: Text('Error'),
            );
        },
      ),
    );
  }
}

Widget compassActionButton(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      OutlineButton(
        onPressed: () {
          LaunchUrl.normalLaunchUrl(
              url: 'https://g.co/qiblafinder', useCustomTabs: true);
        },
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: 'g.co/qiblafinder'))
              .then((value) => Fluttertoast.showToast(msg: 'URL copied :)'));
        },
        highlightedBorderColor: Colors.teal,
        child: Row(
          children: [
            Text('Google Qiblafinder'),
            SizedBox(width: 8),
            FaIcon(FontAwesomeIcons.externalLinkAlt, size: 13)
          ],
        ),
      ),
      SizedBox(width: 10),
      OutlineButton(
        onPressed: () => _showCalibrateCompassDialog(context),
        // onPressed: null,
        highlightedBorderColor: Colors.teal,
        child: Text('Calibrating tip'),
      )
    ],
  );
}

void _showCalibrateCompassDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(10),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Move your phone in "figure 8 pattern".',
                style: TextStyle(fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SvgPicture.asset(
                  'assets/qibla/compass callibrate.svg',
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                  height: 230,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

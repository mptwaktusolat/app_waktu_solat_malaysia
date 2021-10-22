import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/launchUrl.dart';
import '../Qibla%20part/qibla_compass.dart';
import 'no_compass_sensor.dart';

class Qibla extends StatefulWidget {
  const Qibla({Key? key}) : super(key: key);
  @override
  _QiblaState createState() => _QiblaState();
}

class _QiblaState extends State<Qibla> {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qibla Compass'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const Align(
            alignment: Alignment.topCenter,
            child: ListTile(
              leading: FaIcon(FontAwesomeIcons.info),
              title: Text(
                "Align both arrow head\nDo not put device close to metal object.",
                // textAlign: TextAlign.center,
              ),
              trailing: FaIcon(FontAwesomeIcons.exclamation),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: FutureBuilder(
              future: _deviceSupport,
              builder: (context, AsyncSnapshot<bool?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error.toString()}'),
                  );
                }

                if (snapshot.hasData && snapshot.data!) {
                  return const QiblaCompass();
                } else {
                  return const NoCompassSensor();
                }
              },
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: compassActionButton(context))),
        ],
      ),
    );
  }
}

Widget compassActionButton(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      OutlinedButton(
        onPressed: () {
          LaunchUrl.normalLaunchUrl(
              url: 'https://g.co/qiblafinder', useCustomTabs: true);
        },
        onLongPress: () {
          Clipboard.setData(const ClipboardData(text: 'g.co/qiblafinder'))
              .then((value) => Fluttertoast.showToast(msg: 'URL copied :)'));
        },
        child: Row(
          children: const [
            Text('Google Qiblafinder'),
            SizedBox(width: 8),
            FaIcon(FontAwesomeIcons.externalLinkSquareAlt, size: 13)
          ],
        ),
      ),
      const SizedBox(width: 10),
      OutlinedButton(
        onPressed: () => _showCalibrateCompassDialog(context),
        child: const Text('Calibration tip'),
      )
    ],
  );
}

void _showCalibrateCompassDialog(BuildContext context) {
  //TODO: Kasi lawa
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
              const Text(
                'Move your phone in "figure 8 pattern".',
                style: TextStyle(fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SvgPicture.asset(
                  'assets/qibla/compass callibrate.svg',
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

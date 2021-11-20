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
              builder: (_, AsyncSnapshot<bool?> snapshot) {
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
          const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: CompassActionButtons())),
        ],
      ),
    );
  }
}

class CompassActionButtons extends StatelessWidget {
  const CompassActionButtons({Key? key}) : super(key: key);

  final _qiblaFinderUrl = 'g.co/qiblafinder';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          onPressed: () {
            LaunchUrl.normalLaunchUrl(
                url: 'https://$_qiblaFinderUrl', useCustomTabs: true);
          },
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: _qiblaFinderUrl))
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
}

void _showCalibrateCompassDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        title: const Text(
          'Move your phone in "figure 8 pattern"',
          textAlign: TextAlign.center,
        ),
        content: SvgPicture.asset(
          'assets/qibla/compass callibrate.svg',
          height: 230,
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Done'))
        ],
      );
    },
  );
}

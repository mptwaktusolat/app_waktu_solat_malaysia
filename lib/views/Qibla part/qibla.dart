import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/launch_url.dart';
import '../Qibla%20part/qibla_compass.dart';
import 'no_compass_sensor.dart';

class Qibla extends StatefulWidget {
  const Qibla({Key? key}) : super(key: key);
  @override
  State<Qibla> createState() => _QiblaState();
}

class _QiblaState extends State<Qibla> {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.qiblaTitle),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(.3),
                  borderRadius: BorderRadius.circular(16)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FaIcon(FontAwesomeIcons.circleInfo),
                  const SizedBox(width: 15),
                  Flexible(
                    child: Text(
                      AppLocalizations.of(context)!.qiblaOverheadWarn,
                      // textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
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
              child: CompassActionButtons(),
            ),
          ),
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
            Clipboard.setData(ClipboardData(text: _qiblaFinderUrl)).then(
                (value) => Fluttertoast.showToast(
                    msg: AppLocalizations.of(context)!.qiblaCopyUrl));
          },
          child: const Row(
            children: [
              Text('Google Qiblafinder'),
              SizedBox(width: 8),
              FaIcon(FontAwesomeIcons.squareUpRight, size: 13)
            ],
          ),
        ),
        const SizedBox(width: 10),
        OutlinedButton(
          onPressed: () => _showCalibrateCompassDialog(context),
          child: Text(AppLocalizations.of(context)!.qiblaCalibrationTip),
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
        title: Text(
          AppLocalizations.of(context)!.qiblaCalibrate,
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
              child: Text(AppLocalizations.of(context)!.qiblaCalibrateDone))
        ],
      );
    },
  );
}

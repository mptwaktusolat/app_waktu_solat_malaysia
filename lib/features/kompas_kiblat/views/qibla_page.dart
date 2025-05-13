import 'package:admonitions/admonitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../shared/utils/launch_url.dart';
import 'no_compass_sensor.dart';
import 'qibla_compass.dart';

/// Entry point for the Qibla page
class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});
  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
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
            child: PastelAdmonition.caution(
              text: AppLocalizations.of(context)!.qiblaOverheadWarn,
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
  const CompassActionButtons({super.key});

  final _qiblaFinderUrl = 'g.co/qiblafinder';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          onPressed: () {
            LaunchUrl.launchInCustomTab(url: 'https://$_qiblaFinderUrl');
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

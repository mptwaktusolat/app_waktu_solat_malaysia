import 'package:admonitions/admonitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/constants/constants.dart';
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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > constraints.maxHeight &&
                constraints.maxWidth >= kTabletBreakpoint) {
              return _buildHorizontalLayout(context);
            }
            return _buildVerticalLayout(context);
          },
        ),
      ),
    );
  }

  /// Builds the horizontal layout for tablet/landscape mode
  Widget _buildHorizontalLayout(BuildContext context) {
    return Row(
      children: [
        // Left side: Warning and buttons (1/4)
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PastelAdmonition.caution(
                  text: AppLocalizations.of(context)!.qiblaOverheadWarn,
                ),
                const SizedBox(height: 24),
                _buildActionButtons(context, isVertical: true),
              ],
            ),
          ),
        ),
        // Right side: Compass (3/4)
        Expanded(
          flex: 3,
          child: Center(
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
        ),
      ],
    );
  }

  /// Builds the vertical layout for mobile portrait mode
  Widget _buildVerticalLayout(BuildContext context) {
    return Stack(
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
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _buildActionButtons(context, isVertical: false),
          ),
        ),
      ],
    );
  }

  /// Builds action buttons with optional vertical layout
  Widget _buildActionButtons(BuildContext context, {required bool isVertical}) {
    final buttons = [
      OutlinedButton(
        onPressed: () {
          LaunchUrl.launchInCustomTab(url: 'https://g.co/qiblafinder');
        },
        onLongPress: () {
          Clipboard.setData(const ClipboardData(text: 'g.co/qiblafinder')).then(
              (value) => Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.qiblaCopyUrl));
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Google Qiblafinder'),
            const SizedBox(width: 8),
            const FaIcon(FontAwesomeIcons.squareUpRight, size: 13)
          ],
        ),
      ),
      OutlinedButton(
        onPressed: () => _showCalibrateCompassDialog(context),
        child: Text(AppLocalizations.of(context)!.qiblaCalibrationTip),
      ),
    ];

    if (isVertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: buttons
            .map((btn) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: btn,
                ))
            .toList(),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buttons[0],
          const SizedBox(width: 10),
          buttons[1],
        ],
      );
    }
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

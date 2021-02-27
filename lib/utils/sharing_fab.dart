import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:waktusolatmalaysia/utils/launchUrl.dart';
import 'package:waktusolatmalaysia/views/Settings%20part/settingsProvider.dart';
import 'copyAndShare.dart';

class ShareFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingProvider>(builder: (context, setting, child) {
      return FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: FaIcon(FontAwesomeIcons.whatsapp),
        mini: true,
        tooltip: 'Share solat time',
        onPressed: shareToWhatsApp,
      );
    });
  }

  void shareToWhatsApp() => LaunchUrl.normalLaunchUrl(
        url: 'http://wa.me/?text=${CopyAndShare.getMessage(type: 2)}',
      );
}

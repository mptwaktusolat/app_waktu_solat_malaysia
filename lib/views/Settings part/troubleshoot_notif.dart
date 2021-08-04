import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import '../../utils/launchUrl.dart';

class TroubleshootNotif extends StatelessWidget {
  const TroubleshootNotif({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text.rich(
                TextSpan(
                  style: TextStyle(height: 1.3),
                  children: [
                    TextSpan(text: 'Some apps installed from the '),
                    TextSpan(
                        text: 'Google Play Store ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: 'will disable '),
                    TextSpan(
                        text: 'Autostart ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            'by default. Due to this behaviour, prayer notification (sometimes) will not appear on your phone. '),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              const Text.rich(
                TextSpan(
                  style: TextStyle(height: 1.3),
                  children: [
                    TextSpan(text: 'The solution is to enable '),
                    TextSpan(
                        text: 'Autostart ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            'for this app. Tap the button below to open App Setting, then find the Autostart option there to enable it.'),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Card(
                child: ListTile(
                  title: const Text('Open App Setting'),
                  onTap: () => AppSettings.openAppSettings(),
                  trailing: const Icon(Icons.launch_rounded),
                ),
              ),
              const Text(
                '\nRelated Article:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextButton(
                  onPressed: () {
                    LaunchUrl.normalLaunchUrl(
                        url:
                            'https://telegra.ph/Notification-didnt-show-on-some-devices-07-31');
                  },
                  child:
                      const Text('Notification didn\'t show on some devices'))
            ],
          ),
        ),
      ),
    );
  }
}

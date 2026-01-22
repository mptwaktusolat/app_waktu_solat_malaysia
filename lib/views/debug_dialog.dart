import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restart_app/restart_app.dart';

import '../shared/constants/constants.dart';
import '../shared/services/location_service/location_data.dart';
import 'dev/widget_data_page.dart';

class DebugDialog extends StatelessWidget {
  const DebugDialog({super.key});

  @override
  Widget build(BuildContext context) {
    /// Build Flutter version info string
    String getFlutterVersionInfo() {
      final StringBuffer buffer = StringBuffer();
      buffer.write('Version: ${FlutterVersion.version}');
      buffer.write(' ');
      buffer.write('Channel: ${FlutterVersion.channel}');
      return buffer.toString();
    }

    return Dialog(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8.0),
        children: [
          const Text(
            'Debug dialog (for dev)',
            textAlign: TextAlign.center,
          ),
          ListTile(
            title: const Text('Last position'),
            subtitle: Text(LocationData.position?.toString() ?? 'null'),
            onLongPress: () {
              Clipboard.setData(ClipboardData(
                      text: LocationData.position?.toString() ?? 'null'))
                  .then((value) =>
                      Fluttertoast.showToast(msg: 'Copied position'));
            },
          ),
          ListTile(
              title: const Text('Disable ads for 10 minutes'),
              subtitle: const Text('App restart may be required'),
              onTap: () {
                final now = DateTime.now().millisecondsSinceEpoch;
                GetStorage().write(kNoAdsStartTime, now);
                Restart.restartApp();
              }),
          const ListTile(
            title: Text('Notification debug'),
            subtitle: Text('Available on notification settings page'),
          ),
          ListTile(
            title: const Text('Homescreen widget debug'),
            subtitle: const Text('View saved widget data'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const WidgetDataPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Flutter Version'),
            subtitle: Text(getFlutterVersionInfo()),
          ),
        ],
      ),
    );
  }
}

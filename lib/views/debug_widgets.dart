import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';

import '../CONSTANTS.dart';
import '../locationUtil/LocationData.dart';

class DebugWidgets {
  static Dialog debugDialog() {
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
            title: const Text('Prayer time API calls'),
            subtitle:
                Text(GetStorage().read(kStoredApiPrayerCall) ?? 'no calls yet'),
            onLongPress: () {
              Clipboard.setData(ClipboardData(
                      text: GetStorage().read(kStoredApiPrayerCall) ??
                          'no calls yet'))
                  .then((value) => Fluttertoast.showToast(msg: 'Copied url'));
            },
          ),
          ListTile(
            title: const Text('Last position'),
            subtitle: Text(LocationData.position?.toString() ?? 'no detect'),
            onLongPress: () {
              Clipboard.setData(ClipboardData(
                      text: LocationData.position?.toString() ?? 'no detect'))
                  .then((value) =>
                      Fluttertoast.showToast(msg: 'Copied position'));
            },
          ),
          ListTile(
            title: const Text('Current zone'),
            subtitle: Text('${GetStorage().read(kStoredLocationJakimCode)}'),
          ),
          const ListTile(
            title: Text('Notification debug'),
            subtitle: Text('Moved to notification settings page'),
          ),
        ],
      ),
    );
  }
}

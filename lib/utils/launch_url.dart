import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs_lite.dart'
    as custom_tabs;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class LaunchUrl {
  LaunchUrl._();
  static void normalLaunchUrl(
      {required String url, bool useCustomTabs = false}) async {
    print('Launching $url');

    try {
      if (useCustomTabs) {
        custom_tabs.launchUrl(
          Uri.parse(url),
          options: custom_tabs.LaunchOptions(
            barColor: Colors.teal,
            onBarColor: Colors.teal.shade200,
            barFixingEnabled: false,
          ),
        );
      } else {
        await url_launcher.launchUrl(
          Uri.parse(url),
          mode: url_launcher.LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              'Could not launch URL. Error $e.\nPlease send feedback to developer.',
          backgroundColor: Colors.red);
    }
  }
}

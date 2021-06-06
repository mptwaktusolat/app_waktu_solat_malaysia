import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../CONSTANTS.dart';

class LaunchUrl {
  static void normalLaunchUrl(
      {@required String url, bool useCustomTabs = false}) {
    print('Launching $url');

    !useCustomTabs
        ? _launchURL(url)
        : FlutterWebBrowser.openWebPage(
            url: url,
            customTabsOptions: CustomTabsOptions(
                addDefaultShareMenuItem: true,
                navigationBarColor: Colors.tealAccent,
                toolbarColor: Colors.teal.shade700,
                secondaryToolbarColor: Colors.teal));
  }

  static void sendViaEmail(String messageContent) {
    final emailLink = Uri.encodeFull(
        'mailto:$kDevEmail?subject=Feedback MPT&body=$messageContent');
    print(emailLink);
    _launchURL(emailLink);
  }
}

_launchURL(String url) async {
  try {
    await launch(url);
  } catch (e) {
    Fluttertoast.showToast(
        msg:
            'Could not launch URL. Error $e.\nPlease send feedback to developer.',
        backgroundColor: Colors.red);
  }
}

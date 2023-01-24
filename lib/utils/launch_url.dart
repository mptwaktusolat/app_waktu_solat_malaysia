import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchUrl {
  LaunchUrl._();
  static void normalLaunchUrl(
      {required String url, bool useCustomTabs = false}) {
    print('Launching $url');

    !useCustomTabs
        ? _launchURL(Uri.parse(url))
        : FlutterWebBrowser.openWebPage(
            url: url,
            customTabsOptions: CustomTabsOptions(
              shareState: CustomTabsShareState.on,
              defaultColorSchemeParams: CustomTabsColorSchemeParams(
                toolbarColor: Colors.teal.shade700,
                secondaryToolbarColor: Colors.teal,
              ),
            ),
          );
  }
}

_launchURL(Uri uri) async {
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (e) {
    Fluttertoast.showToast(
        msg:
            'Could not launch URL. Error $e.\nPlease send feedback to developer.',
        backgroundColor: Colors.red);
  }
}

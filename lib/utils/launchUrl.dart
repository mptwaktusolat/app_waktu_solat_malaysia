import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart';

class LaunchUrl {
  static void normalLaunchUrl(
      {String url, bool usesWebView = false, bool useCustomTabs = false}) {
    print('Launching $url');

    !useCustomTabs
        ? _launchURL(url, usesWebView)
        : FlutterWebBrowser.openWebPage(
            url: url,
            customTabsOptions: CustomTabsOptions(
                toolbarColor: Colors.teal.shade700,
                secondaryToolbarColor: Colors.teal));
  }

  static void sendViaEmail(String messageContent) {
    final emailLink = Uri.encodeFull(
        'mailto:$kDevEmail?subject=Feedback MPT&body=$messageContent');
    print(emailLink);
    _launchURL(emailLink, false);
  }
}

_launchURL(String url, bool isWebView) async {
  if (await canLaunch(url)) {
    await launch(url, forceWebView: isWebView);
  } else {
    Fluttertoast.showToast(
        msg: 'Could not launch url. Please send feedback to developer.');
    throw 'Could not launch $url';
  }
}

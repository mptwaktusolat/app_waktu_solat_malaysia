import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart';

class LaunchUrl {
  static void normalLaunchUrl({String url, bool usesWebView = false}) {
    print('Normal launching $url');
    _launchURL(url, usesWebView);
  }

  static void sendViaEmail(String messageContent) {
    final emailLink = Uri.encodeFull(
        'mailto:$kDevEmail?subject=Feedback MPT&body=$messageContent');
    print(emailLink);
    _launchURL(emailLink, false);
  }

  static void customTabsUrl(String url) {
    print('Called custom tabs: $url');
    //TODO: Custom tabs
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

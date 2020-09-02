import 'package:url_launcher/url_launcher.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart';

class LaunchUrl {
  static void normalLaunchUrl({String url}) {
    print('Normal launching $url');
    _launchURL(url);
  }

  static void sendViaEmail(String emailAddress, String messageContent) {
    final Uri _emailLaunchUri = Uri(
        scheme: 'mailto',
        path: kDevEmail,
        queryParameters: {'subject': messageContent});
    print(_emailLaunchUri.toString());
    // _launchURL(_emailLaunchUri.toString());
  }

  static void customTabsUrl(String url) {
    print('Called custom tabs: $url');
    //TODO: Custom tabs
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

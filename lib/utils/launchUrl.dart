import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../CONSTANTS.dart';

class LaunchUrl {
  static void normalLaunchUrl({String url}) {
    print('Launching $url');
    _launchURL(url);
  }

  static void sendViaEmail(String messageContent) {
    final emailLink = Uri.encodeFull(
        'mailto:$kDevEmail?subject=Feedback MPT&body=$messageContent');
    print(emailLink);
    _launchURL(emailLink);
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    Fluttertoast.showToast(
        webBgColor: "linear-gradient(to right, #de6161, #2657eb)",
        msg: 'Could not launch url. Please send feedback to developer.');
    throw 'Could not launch $url';
  }
}

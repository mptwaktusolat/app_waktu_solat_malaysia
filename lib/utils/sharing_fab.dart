import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import '../views/Settings%20part/settingsProvider.dart';
import 'copyAndShare.dart';
import 'launchUrl.dart';

class ShareFAB extends StatelessWidget {
  const ShareFAB({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingProvider>(builder: (context, setting, child) {
      return FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: FaIcon(setting.sharingFormat == 2
            ? FontAwesomeIcons.whatsapp
            : FontAwesomeIcons.shareAlt),
        mini: true,
        tooltip: 'Share solat time',
        onPressed: () {
          switch (setting.sharingFormat) {
            case 1:
              shareUniversal();
              break;
            case 2:
              shareToWhatsApp();
              break;
            default:
              showShareDialog(context);
              break;
          }
        },
      );
    });
  }

  void showShareDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Share as plain text'),
              subtitle: const Text('Compatible to all apps'),
              onTap: () {
                Navigator.pop(context);
                shareUniversal();
              },
            ),
            ListTile(
              title: const Text('Share to WhatsApp'),
              subtitle: const Text('Using WhatsApp compatible format'),
              trailing: const FaIcon(FontAwesomeIcons.whatsapp),
              onTap: () {
                Navigator.pop(context);
                shareToWhatsApp();
              },
            ),
            Padding(
                padding: const EdgeInsets.all(10),
                child: RichText(
                  text: TextSpan(
                    text: 'You can set defaults in ',
                    style: DefaultTextStyle.of(context)
                        .style
                        .copyWith(fontSize: 12),
                    children: const <TextSpan>[
                      TextSpan(
                          text: 'Setting -> Sharing',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                )),
          ],
        );
      },
    );
  }

  void shareToWhatsApp() => LaunchUrl.normalLaunchUrl(
        url: 'http://wa.me/?text=${CopyAndShare.getMessage(type: 2)}',
      );

  void shareUniversal() => Share.share(CopyAndShare.getMessage(),
      subject: 'Malaysia prayer time for today');
}

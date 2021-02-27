import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:waktusolatmalaysia/utils/launchUrl.dart';
import 'package:waktusolatmalaysia/views/Settings%20part/settingsProvider.dart';
import 'copyAndShare.dart';

class ShareFAB extends StatelessWidget {
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
              title: Text('Share as plain text'),
              subtitle: Text('Compatible to all apps'),
              onTap: () {
                Navigator.pop(context);
                shareUniversal();
              },
            ),
            ListTile(
              title: Text('Share to WhatsApp'),
              subtitle: Text('Using WhatsApp compatible format'),
              trailing: FaIcon(FontAwesomeIcons.whatsapp),
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
                    children: <TextSpan>[
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

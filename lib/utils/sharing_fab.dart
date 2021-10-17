import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/settingsProvider.dart';
import '../CONSTANTS.dart';
import 'copyAndShare.dart';
import 'launchUrl.dart';

class ShareFAB extends StatelessWidget {
  const ShareFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingProvider>(builder: (context, setting, child) {
      return FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Builder(
          builder: (context) {
            switch (setting.sharingFormat) {
              case 2:
                return const FaIcon(FontAwesomeIcons.whatsapp);
              case 3:
                return const FaIcon(FontAwesomeIcons.clone);
              default:
                return const FaIcon(FontAwesomeIcons.shareAlt);
            }
          },
        ),
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
            case 3:
              copy();
              break;
            default:
              showShareDialog(context);
              break;
          }
        },
      );
    });
  }

  void showShareDialog(BuildContext context) async {
    await showModalBottomSheet(
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
            ListTile(
              title: const Text('Copy to clipboard'),
              trailing: const FaIcon(FontAwesomeIcons.clone),
              onTap: () {
                copy();
                Navigator.pop(context);
              },
            ),
            // Message should only show once
            GetStorage().read(kHasOpenSharingDialog) ?? false
                ? const SizedBox.shrink()
                : Padding(
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
                    ),
                  ),
          ],
        );
      },
    );
    GetStorage().write(kHasOpenSharingDialog, true);
  }

  void shareToWhatsApp() => LaunchUrl.normalLaunchUrl(
        url: 'http://wa.me/?text=${CopyAndShare.getMessage(type: 2)}',
      );

  void shareUniversal() => Share.share(CopyAndShare.getMessage(),
      subject: 'Malaysia prayer time for today');

  void copy() =>
      Clipboard.setData(ClipboardData(text: CopyAndShare.getMessage())).then(
        (value) {
          Fluttertoast.showToast(msg: 'Timetable copied');
        },
      );
}

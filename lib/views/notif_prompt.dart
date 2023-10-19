import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_storage/get_storage.dart';

import '../constants.dart';
import 'settings/notification_page_setting.dart';

/// It will ask "Is notification is show at prayer time" in appbody

class NotifPrompt extends StatefulWidget {
  const NotifPrompt({super.key});

  @override
  State<NotifPrompt> createState() => _NotifPromptState();
}

class _NotifPromptState extends State<NotifPrompt> {
  bool _showFirstChild = true;
  late bool _shouldShowNotifPrompt;
  @override
  void initState() {
    super.initState();
    _shouldShowNotifPrompt = GetStorage().read(kShowNotifPrompt) &&
        GetStorage().read(kAppLaunchCount) > 5;
  }

  @override
  Widget build(BuildContext context) {
    if (_shouldShowNotifPrompt) {
      return AnimatedCrossFade(
        layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) {
          return Stack(
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                key: bottomChildKey,
                child: bottomChild,
              ),
              Positioned(
                key: topChildKey,
                child: topChild,
              )
            ],
          );
        },
        duration: const Duration(milliseconds: 200),
        crossFadeState: _showFirstChild
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        firstChild: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Opacity(
                opacity: 0.8,
                child: Text(
                  AppLocalizations.of(context)!.appBodyNotifPrompt,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      setState(() => _showFirstChild = false);
                      Future.delayed(const Duration(seconds: 3))
                          .then((value) => setState(() {
                                _shouldShowNotifPrompt = false;
                                GetStorage().write(kShowNotifPrompt, false);
                              }));
                    },
                    child: Text(
                        AppLocalizations.of(context)!.appBodyNotifPromptYes)),
                TextButton(
                  style: TextButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            settings: const RouteSettings(
                                name: 'Notification Settings'),
                            builder: (_) => const NotificationPageSetting()));
                  },
                  child:
                      Text(AppLocalizations.of(context)!.appBodyNotifPromptNo),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    setState(() {
                      _shouldShowNotifPrompt = false;
                      GetStorage().write(kShowNotifPrompt, false);
                    });
                  },
                  child: Text(
                      AppLocalizations.of(context)!.appBodyNotifPromptDissm),
                )
              ],
            )
          ],
        ),
        secondChild: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Opacity(
            opacity: 0.8,
            child: Text(
              AppLocalizations.of(context)!.appBodyNotifPromptResponse,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    } else {
      return const SizedBox(height: 10);
    }
  }
}

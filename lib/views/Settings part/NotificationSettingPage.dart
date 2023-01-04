import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../CONSTANTS.dart';
import '../../notificationUtil/notifications_helper.dart';
import '../../providers/settingsProvider.dart';
import '../../utils/cupertinoSwitchListTile.dart';
import 'troubleshoot_notif.dart';

enum MyNotificationType { noazan, azan, shortAzan }

/// Notification setting page to change notification type,
/// troubleshooting, and system notification settings and debug notification
class NotificationPageSetting extends StatefulWidget {
  const NotificationPageSetting({Key? key}) : super(key: key);
  @override
  State<NotificationPageSetting> createState() =>
      _NotificationPageSettingState();
}

class _NotificationPageSettingState extends State<NotificationPageSetting> {
  MyNotificationType _type =
      MyNotificationType.values[GetStorage().read(kNotificationType)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingNotification),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(AppLocalizations.of(context)!.notifSettingBasic)),
          Card(
              child: ListView(
            shrinkWrap: true,
            children: [
              RadioListTile(
                  value: MyNotificationType.noazan,
                  groupValue: _type,
                  title: Text(
                      AppLocalizations.of(context)!.onboardingNotifDefault),
                  onChanged: (MyNotificationType? type) {
                    setState(() => _type = type!);
                  }),
              RadioListTile(
                  value: MyNotificationType.shortAzan,
                  groupValue: _type,
                  title: Text(
                      AppLocalizations.of(context)!.onboardingNotifShortAzan),
                  onChanged: (MyNotificationType? type) {
                    setState(() => _type = type!);
                  }),
              RadioListTile(
                  value: MyNotificationType.azan,
                  groupValue: _type,
                  title:
                      Text(AppLocalizations.of(context)!.onboardingNotifAzan),
                  onChanged: (MyNotificationType? type) {
                    setState(() => _type = type!);
                  }),
              Builder(builder: (_) {
                if (_type !=
                    MyNotificationType
                        .values[GetStorage().read(kNotificationType)]) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .notifSettingChangesDetect,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              // mark as need to update notification
                              // when the app restart
                              GetStorage().write(kShouldUpdateNotif, true);
                              GetStorage()
                                  .write(kNotificationType, _type.index);
                              Restart.restartApp();
                            },
                            child: Text(AppLocalizations.of(context)!
                                .notifSettingRestartApp)),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
            ],
          )),
          Card(
            child: ListTile(
              title: Text(AppLocalizations.of(context)!.notifSettingSysSetting),
              isThreeLine: true,
              subtitle: Text(
                  AppLocalizations.of(context)!.notifSettingSysSettingDesc),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.launch_rounded),
                ],
              ),
              onTap: () async {
                await AppSettings.openNotificationSettings();
              },
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text(AppLocalizations.of(context)!.notifSettingTroubleshoot)),
          Card(
            child: ListTile(
              title: Text(
                  AppLocalizations.of(context)!.notifSettingTroubleshootDesc),
              subtitle: Text(AppLocalizations.of(context)!
                  .notifSettingTroubleshootExample("Xiaomi / Redmi, Realme")),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    settings: const RouteSettings(
                        name: 'Notification troubleshoot page'),
                    builder: (_) => const TroubleshootNotif(),
                  )),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(AppLocalizations.of(context)!
                  .notifSettingAdvancedTroubleshoot)),
          Card(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CupertinoSwitchListTile(
                  activeColor: CupertinoColors.activeBlue,
                  title: Text(
                      AppLocalizations.of(context)!.notifSettingLimitNotif),
                  subtitle: Text(
                      AppLocalizations.of(context)!.notifSettingLimitNotifDesc),
                  value: GetStorage().read(kStoredNotificationLimit),
                  onChanged: (value) {
                    setState(() {
                      GetStorage().write(kStoredNotificationLimit, value);
                    });
                  }),
            ),
          ),
          Card(
            child: ListTile(
              title: Text(
                  AppLocalizations.of(context)!.notifSettingForceReschedule),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text(AppLocalizations.of(context)!
                          .notifSettingForceRescheduleDesc),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                              AppLocalizations.of(context)!.notifSettingCancel),
                        ),
                        TextButton(
                          onPressed: () {
                            GetStorage().write(kShouldUpdateNotif, true);
                            Restart.restartApp();
                          },
                          child: Text(AppLocalizations.of(context)!
                              .notifSettingProceed),
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ),
          if (Provider.of<SettingProvider>(context, listen: false)
              .isDeveloperOption)
            const _DebugNotifWidget(),
        ],
      ),
    );
  }
}

/// Widget for debug notification
/// Only shown when (App) developer option is enabled
class _DebugNotifWidget extends StatelessWidget {
  const _DebugNotifWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Debug (for dev)",
          ),
        ),
        Card(
          child: ListTile(
            title: const Text('Send immediate test notification'),
            subtitle: const Text('Without azan'),
            onTap: () async {
              await showDebugNotification();
            },
          ),
        ),
        Card(
          child: ListTile(
            title: const Text('Send azan test in 15 secs'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      await scheduleSingleAzanNotification(
                          name: 'name1',
                          id: 2321,
                          title: 'Azan test Full',
                          body: 'azan_hejaz2013_fajr',
                          customSound: 'azan_hejaz2013_fajr',
                          scheduledTime: tz.TZDateTime.now(tz.local)
                              .add(const Duration(seconds: 15)));
                    },
                    child: const Text('Full')),
                const SizedBox(width: 5),
                ElevatedButton(
                    onPressed: () async {
                      await scheduleSingleAzanNotification(
                          name: 'name2',
                          id: 2122,
                          title: 'Azan test short',
                          body: 'azan_short_lamy2005',
                          customSound: 'azan_short_lamy2005',
                          scheduledTime: tz.TZDateTime.now(tz.local)
                              .add(const Duration(seconds: 15)));
                    },
                    child: const Text('Short'))
              ],
            ),
          ),
        ),
        ListTile(
          title: const Text('Last update notification'),
          subtitle: Text(DateTime.fromMillisecondsSinceEpoch(
                  GetStorage().read(kStoredLastUpdateNotif))
              .toString()),
          onLongPress: () {
            Clipboard.setData(ClipboardData(
                    text: GetStorage().read(kStoredLastUpdateNotif).toString()))
                .then((value) => Fluttertoast.showToast(msg: 'Copied millis'));
          },
        ),
        FutureBuilder<List<PendingNotificationRequest>>(
            future:
                FlutterLocalNotificationsPlugin().pendingNotificationRequests(),
            builder:
                (_, AsyncSnapshot<List<PendingNotificationRequest>> snapshot) {
              return ExpansionTile(
                title: const Text("Pending Notification Requests"),
                subtitle: Text(snapshot.data?.length.toString() ?? "no data"),
                children: snapshot.hasData
                    ? snapshot.data!
                        .map((e) => ListTile(
                              trailing: Text(e.id.toString()),
                              title: Text(e.title!),
                              subtitle: Text(e.body!),
                            ))
                        .toList()
                    : const [
                        ListTile(
                          subtitle: Text("Please wait"),
                        )
                      ],
              );
            }),
      ],
    );
  }
}

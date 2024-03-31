import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../constants.dart';
import '../../notificationUtil/notifications_helper.dart';
import '../../providers/setting_provider.dart';
import 'troubleshoot_notif.dart';

enum MyNotificationType { noazan, azan, shortAzan }

/// Notification setting page to change notification type,
/// troubleshooting, and system notification settings and debug notification
class NotificationPageSetting extends StatefulWidget {
  const NotificationPageSetting({super.key});
  @override
  State<NotificationPageSetting> createState() =>
      _NotificationPageSettingState();
}

class _NotificationPageSettingState extends State<NotificationPageSetting> {
  MyNotificationType _type =
      MyNotificationType.values[GetStorage().read(kNotificationType)];

  // to make sure only one banner is shown at a time
  ScaffoldFeatureController<MaterialBanner, MaterialBannerClosedReason>?
      _bannerController;

  /// Copied from lib/notificationUtil/notification_scheduler.dart
  Future<bool> _canScheduleNotification() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    final androidNotif =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    // underlying implementation: https://github.com/MaikuB/flutter_local_notifications/blob/ca71c96ba2a245175b44471e2e41e4958d480876/flutter_local_notifications/android/src/main/java/com/dexterous/flutterlocalnotifications/FlutterLocalNotificationsPlugin.java#L2119
    final res = await androidNotif?.canScheduleExactNotifications();
    return res ?? false;
  }

  /// Request permission kalau belum dapat permission. Kalau dah dapat, just
  /// open the relevant setting page
  void _requestOrOpenAlarmPermission() async {
    // check dulu permissionnya
    final dahAdaPermissionScheduleAlarm = await _canScheduleNotification();

    if (dahAdaPermissionScheduleAlarm) {
      AppSettings.openAppSettings(type: AppSettingsType.alarm);
      return;
    }

    // kalau belum, request permission
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    final scheduleExactAlarmPermission = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();

    debugPrint('scheduleExactAlarmPermission: $scheduleExactAlarmPermission');
  }

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
              clipBehavior: Clip.hardEdge,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile(
                      value: MyNotificationType.noazan,
                      groupValue: _type,
                      title: Row(
                        children: [
                          Text(AppLocalizations.of(context)!
                              .onboardingNotifDefault),
                          const Spacer(),
                          IconButton(
                              onPressed: () {
                                fireDefaultNotification(
                                  message: AppLocalizations.of(context)!
                                      .notifSettingNotifDemo,
                                );
                              },
                              tooltip: AppLocalizations.of(context)!
                                  .notificationSettingPlayNotifTooltip,
                              icon: const Icon(Icons.play_arrow)),
                        ],
                      ),
                      onChanged: (MyNotificationType? type) {
                        setState(() => _type = type!);
                        _handleRestartBanner();
                      }),
                  RadioListTile(
                      value: MyNotificationType.shortAzan,
                      groupValue: _type,
                      title: Row(
                        children: [
                          Text(AppLocalizations.of(context)!
                              .onboardingNotifShortAzan),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              fireAzanNotification(
                                type: MyNotificationType.shortAzan,
                                message: AppLocalizations.of(context)!
                                    .notifSettingNotifDemo,
                              );
                            },
                            tooltip: AppLocalizations.of(context)!
                                .notificationSettingPlayNotifTooltip,
                            icon: const Icon(Icons.play_arrow),
                          ),
                        ],
                      ),
                      onChanged: (MyNotificationType? type) {
                        setState(() => _type = type!);
                        _handleRestartBanner();
                      }),
                  RadioListTile(
                      value: MyNotificationType.azan,
                      groupValue: _type,
                      title: Row(
                        children: [
                          Text(AppLocalizations.of(context)!
                              .onboardingNotifAzan),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              fireAzanNotification(
                                type: MyNotificationType.azan,
                                message: AppLocalizations.of(context)!
                                    .notifSettingNotifDemo,
                              );
                            },
                            tooltip: AppLocalizations.of(context)!
                                .notificationSettingPlayNotifTooltip,
                            icon: const Icon(Icons.play_arrow),
                          ),
                        ],
                      ),
                      onChanged: (MyNotificationType? type) {
                        setState(() => _type = type!);
                        _handleRestartBanner();
                      }),
                ],
              )),
          Card(
            clipBehavior: Clip.hardEdge,
            child: ListTile(
              title: Text(AppLocalizations.of(context)!.notifSettingSysSetting),
              isThreeLine: true,
              subtitle: Text(
                  AppLocalizations.of(context)!.notifSettingSysSettingDesc),
              trailing: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.launch_rounded),
                ],
              ),
              onTap: () {
                // Kalau user tekan part ni, maybe dia berminat nak turn on notification, so
                // disable keep off sheet notification [tengok dalam app_body.dart]
                GetStorage().write(kNotificationSheetKeepOff, false);

                AppSettings.openAppSettings(type: AppSettingsType.notification);
              },
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text(AppLocalizations.of(context)!.notifSettingTroubleshoot)),
          Card(
            clipBehavior: Clip.hardEdge,
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
          FutureBuilder(
              future: _canScheduleNotification(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                if (snapshot.data ?? false) {
                  return Card(
                    clipBehavior: Clip.hardEdge,
                    child: ListTile(
                      onTap: _requestOrOpenAlarmPermission,
                      title: Text(AppLocalizations.of(context)!
                          .notifSettingsExactAlarmPermissionTitle),
                      subtitle: Text(AppLocalizations.of(context)!
                          .notifSettingsExactAlarmPermissionGrantedSubtitle),
                    ),
                  );
                } else {
                  // If not granted, highlight this option in yellow to draw user attention
                  return Card(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.yellow[100]
                        : Colors.yellow.withAlpha(60),
                    clipBehavior: Clip.hardEdge,
                    child: ListTile(
                      title: Text(AppLocalizations.of(context)!
                          .notifSettingsExactAlarmPermissionTitle),
                      isThreeLine: true,
                      subtitle: Text(AppLocalizations.of(context)!
                          .notifSettingsExactAlarmPermissionNotGrantedSubtitle),
                      onTap: _requestOrOpenAlarmPermission,
                    ),
                  );
                }
              }),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(AppLocalizations.of(context)!
                  .notifSettingAdvancedTroubleshoot)),
          Card(
            clipBehavior: Clip.hardEdge,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SwitchListTile(
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
            clipBehavior: Clip.hardEdge,
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

  /// Handle showing/hiding of banner when the user change the notification type
  void _handleRestartBanner() async {
    final currentNotifType =
        MyNotificationType.values[GetStorage().read(kNotificationType)];

    // show if new type is different from the old one (stored in storage)
    if (_type != currentNotifType) {
      // if material banner already shown, do nothing
      if (_bannerController != null) return;

      // show material banner
      _bannerController = ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(
              content:
                  Text(AppLocalizations.of(context)!.notifSettingChangesDetect),
              actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.notifSettingRestartApp),
              onPressed: () {
                // mark as need to update notification
                // when the app restart
                GetStorage().write(kShouldUpdateNotif, true);
                GetStorage().write(kNotificationType, _type.index);
                Restart.restartApp();
              },
            )
          ]));
    } else {
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
      _bannerController = null;
    }
  }
}

/// Widget for debug notification
/// Only shown when (App) developer option is enabled
class _DebugNotifWidget extends StatelessWidget {
  const _DebugNotifWidget();

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

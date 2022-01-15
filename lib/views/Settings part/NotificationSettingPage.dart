import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restart_app/restart_app.dart';

import '../../CONSTANTS.dart';
import '../../utils/cupertinoSwitchListTile.dart';
import 'troubleshoot_notif.dart';

enum MyNotificationType { noazan, azan }

class NotificationPageSetting extends StatefulWidget {
  const NotificationPageSetting({Key? key}) : super(key: key);
  @override
  _NotificationPageSettingState createState() =>
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
                              GetStorage().write(kForceUpdateNotif, true);
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
                            GetStorage().write(kForceUpdateNotif, true);
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
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../providers/locale_provider.dart';
import '../../providers/setting_provider.dart';
import 'about_page.dart';
import 'notification_page_setting.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingTitle),
        centerTitle: true,
      ),
      body: Consumer<SettingProvider>(
        builder: (_, setting, __) {
          return ListView(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(AppLocalizations.of(context)!.settingDisplay)),
              const TimeFormatSettings(),
              const SizedBox(height: 3),
              const OtherTimesSettings(),
              const SizedBox(height: 3),
              const FontSizeSetting(),
              const SizedBox(height: 3),
              const LocaleSetting(),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text(AppLocalizations.of(context)!.settingNotification)),
              const NotificationSetting(),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(AppLocalizations.of(context)!.settingSharing)),
              const SharingSetting(),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(AppLocalizations.of(context)!.settingMore)),
              const AboutApp(),
              const SizedBox(height: 3),
              if (setting.isDeveloperOption) ...[
                const VerboseDebugDialog(),
                const SizedBox(height: 3),
                const ClearCachedMptResponse(),
                const SizedBox(height: 3),
                const ResetAllSavedData(),
              ],
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }
}

class LocaleSetting extends StatelessWidget {
  const LocaleSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Consumer<LocaleProvider>(
        builder: (_, value, __) {
          return ListTile(
            title: Text(AppLocalizations.of(context)!.settingLocaleTitle),
            trailing: DropdownButton<String>(
              value: value.appLocale,
              items: {"en": "English", "ms": "Bahasa Malaysia"}
                  .entries
                  .map((e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(
                          e.value,
                        ),
                      ))
                  .toList(),
              onChanged: (newValue) {
                value.appLocale = newValue!;
              },
            ),
          );
        },
      ),
    );
  }
}

class FontSizeSetting extends StatelessWidget {
  const FontSizeSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Consumer<SettingProvider>(
        builder: (_, value, __) => ListTile(
          title: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(AppLocalizations.of(context)!.settingFontSize),
          ),
          subtitle: Slider(
            label: value.prayerFontSize.round().toString(),
            min: 12.0,
            max: 24.0,
            divisions: 6,
            value: value.prayerFontSize,
            onChanged: (double newValue) => value.prayerFontSize = newValue,
          ),
        ),
      ),
    );
  }
}

class SharingSetting extends StatelessWidget {
  const SharingSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Consumer<SettingProvider>(
        builder: (_, value, __) => ListTile(
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 2.0),
            child: Text(
              AppLocalizations.of(context)!.settingShareDefault,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            // pakai SegmentedButton tak lawa sangat
            child: CupertinoSlidingSegmentedControl(
              groupValue: value.sharingFormat,
              onValueChanged: (dynamic newValue) =>
                  value.sharingFormat = newValue,
              children: {
                //defaulted to always ask
                0: Text(AppLocalizations.of(context)!.settingShareAsk),
                1: Text(AppLocalizations.of(context)!.settingPlain),
                2: const Text("WhatsApp"),
                3: Text(AppLocalizations.of(context)!.settingCopy)
              },
            ),
          ),
        ),
      ),
    );
  }
}

class VerboseDebugDialog extends StatelessWidget {
  const VerboseDebugDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text('Verbose debug mode'),
        subtitle: const Text('For developer purposes'),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(GetStorage().read(kIsDebugMode)
                    ? 'Verbose debug mode is ON'
                    : 'Verbose debug mode is OFF'),
                contentPadding:
                    const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 1.0),
                content: const Text(
                    'Toast message or similar will show throughout usage of the app'),
                actions: [
                  TextButton(
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                      child: const Text('Cancel')),
                  TextButton(
                    onPressed: () {
                      //inverse if false then become true & vice versa
                      GetStorage().write(
                          kIsDebugMode, !GetStorage().read(kIsDebugMode));
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: GetStorage().read(kIsDebugMode)
                        ? const Text('Turn off')
                        : const Text(
                            'Turn on',
                            style: TextStyle(color: Colors.red),
                          ),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class ResetAllSavedData extends StatelessWidget {
  const ResetAllSavedData({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text('Reset all setting'),
        subtitle: const Text('Deletes all GetStorage() items'),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                contentPadding:
                    const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 1.0),
                content:
                    const Text('Proceed? The app will exit automatically.'),
                actions: [
                  TextButton(
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                      child: const Text('Cancel')),
                  TextButton(
                    onPressed: () => GetStorage().erase().then((value) => {
                          Fluttertoast.showToast(msg: 'Reset done'),
                          SystemNavigator.pop()
                        }),
                    child: const Text(
                      'Yes. Reset all',
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class ClearCachedMptResponse extends StatelessWidget {
  const ClearCachedMptResponse({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text('Clear cached MPT response(s)'),
        onTap: () async {
          // find the cache file
          final cachedKeys = GetStorage()
              .getKeys()
              .where((element) =>
                  element.toString().startsWith('mpt-server-cache'))
              .toList();
          // delete the cache file
          await cachedKeys.forEach((element) => GetStorage().remove(element));
          Fluttertoast.showToast(msg: 'MPT caches cleared');
        },
      ),
    );
  }
}

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (_, AsyncSnapshot<PackageInfo> snapshot) {
          if (snapshot.hasData) {
            return ListTile(
              title: Text(AppLocalizations.of(context)!
                  .settingAbout(snapshot.data!.version)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    settings: const RouteSettings(name: 'About Page'),
                    builder: (_) => AboutAppPage(packageInfo: snapshot.data),
                  ),
                );
              },
              subtitle: Text(AppLocalizations.of(context)!.settingMoreDesc),
            );
          } else {
            return const ListTile(
              leading: SizedBox(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}

class NotificationSetting extends StatelessWidget {
  const NotificationSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        title: Text(AppLocalizations.of(context)!.settingNotification2),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              settings: const RouteSettings(name: 'Notification Settings Page'),
              builder: (_) => const NotificationPageSetting(),
            ),
          );
        },
      ),
    );
  }
}

class OtherTimesSettings extends StatelessWidget {
  const OtherTimesSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Consumer<SettingProvider>(
        builder: (_, value, __) => SwitchListTile(
          title: Text(AppLocalizations.of(context)!.settingOtherPrayer),
          // display 'Imsak, Syuruk & DHuha' according to locale
          subtitle: Text(
              '${AppLocalizations.of(context)!.imsakName}, ${AppLocalizations.of(context)!.sunriseName} & ${AppLocalizations.of(context)!.dhuhaName}'),
          onChanged: (bool newValue) => value.showOtherPrayerTime = newValue,
          value: value.showOtherPrayerTime,
        ),
      ),
    );
  }
}

class TimeFormatSettings extends StatelessWidget {
  const TimeFormatSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Consumer<SettingProvider>(
        builder: (_, value, __) => ListTile(
          title: Text(AppLocalizations.of(context)!.settingTimeFormat),
          trailing: DropdownButton(
            icon: const Padding(
              padding: EdgeInsets.all(4.0),
              child: FaIcon(FontAwesomeIcons.caretDown, size: 13),
            ),
            // check dropdown ni borken atau tak
            items: [12, 24].map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value, // yes, this is the value
                child: Text(AppLocalizations.of(context)!
                    .settingTimeFormatDropdown(value.toString())),
              );
            }).toList(),
            onChanged: (int? newValue) => value.use12hour = (newValue == 12),
            value: value.use12hour ? 12 : 24,
          ),
        ),
      ),
    );
  }
}

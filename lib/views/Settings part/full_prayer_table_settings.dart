import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../providers/timetable_provider.dart';

enum HijriStyle { full, short }

class FullPrayerTableSettings extends StatelessWidget {
  const FullPrayerTableSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.timetableSettingTitle),
        centerTitle: true,
      ),
      body: Consumer<TimetableProvider>(
        builder: (_, value, __) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              clipBehavior: Clip.hardEdge,
              child: SwitchListTile(
                  title:
                      Text(AppLocalizations.of(context)!.timetableSettingHijri),
                  value: value.showHijri,
                  onChanged: (bool newValue) {
                    value.showHijri = newValue;
                  }),
            ),
            if (value.showHijri)
              Card(
                child: ListTile(
                  title: Text(
                      AppLocalizations.of(context)!.timetableSettingHijriStyle),
                  trailing: DropdownButton<HijriStyle>(
                    value: value.hijriStyle,
                    items: {
                      HijriStyle.short: AppLocalizations.of(context)!
                          .timetableSettingShortform,
                      HijriStyle.full:
                          AppLocalizations.of(context)!.timetableSettingLongform
                    }
                        .entries
                        .map((e) => DropdownMenuItem(
                              value: e.key,
                              child: Text(e.value),
                            ))
                        .toList(),
                    onChanged: (newValue) {
                      value.hijriStyle = newValue!;
                    },
                  ),
                ),
              ),
            Card(
                clipBehavior: Clip.hardEdge,
                child: SwitchListTile(
                  title: Text(
                      AppLocalizations.of(context)!.timetableSettingOneThird),
                  subtitle: Text(AppLocalizations.of(context)!
                      .timetableSettingOneThirdSub),
                  isThreeLine: true,
                  value: value.showLastOneThirdNight,
                  onChanged: (bool newValue) {
                    value.showLastOneThirdNight = newValue;
                  },
                ))
          ],
        ),
      ),
    );
  }
}

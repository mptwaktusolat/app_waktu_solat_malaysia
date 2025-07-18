import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../../l10n/app_localizations.dart';
import '../zone_chooser.dart';

class ZoneErrorWidget extends StatelessWidget {
  const ZoneErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Center(
                child: Text(AppLocalizations.of(context)!.zoneError),
              )),
          Expanded(
            flex: 3,
            child: DefaultTextStyle(
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fmd_bad_outlined,
                    size: 40,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  MarkdownBody(
                    data: AppLocalizations.of(context)!.zoneErrorPara1,
                    styleSheet: MarkdownStyleSheet(
                        textAlign: WrapAlignment.center,
                        p: TextStyle(
                            color: Theme.of(context).colorScheme.error)),
                  ),
                  const SizedBox(height: 10),
                  MarkdownBody(
                    data: AppLocalizations.of(context)!.zoneErrorPara2,
                    styleSheet: MarkdownStyleSheet(
                      textAlign: WrapAlignment.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => AppSettings.openAppSettings(
                    type: AppSettingsType.location,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.zoneOpenLocationSettings,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await LocationChooser.openManualZoneSelector(context);
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.zoneSetManually,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

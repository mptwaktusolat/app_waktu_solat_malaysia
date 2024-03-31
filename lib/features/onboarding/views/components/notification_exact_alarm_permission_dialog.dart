import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationExactAlarmPermissionDialog extends StatelessWidget {
  const NotificationExactAlarmPermissionDialog({
    super.key,
    required this.leadingCount,
    required this.onSkip,
    required this.onGrantPermission,
  });

  final String leadingCount;
  final VoidCallback onSkip;
  final VoidCallback onGrantPermission;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.permissionDialogTitle),
      content:
          Text('$leadingCount) ${l10n.notifExactAlarmDialogPermissionContent}'),
      actions: [
        TextButton(
          onPressed: onSkip,
          child: Text(l10n.permissionDialogSkip),
        ),
        TextButton(
          onPressed: onGrantPermission,
          child: Text(l10n.permissionDialogGrant),
        )
      ],
    );
  }
}

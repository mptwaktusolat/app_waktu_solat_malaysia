import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationPermissionDialog extends StatelessWidget {
  const NotificationPermissionDialog(
      {super.key, required this.leadingCount, required this.onGrantPermission});

  final String leadingCount;
  final VoidCallback onGrantPermission;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.permissionDialogTitle),
      content: Text('$leadingCount) ${l10n.notifDialogPermissionContent}'),
      actions: [
        TextButton(
          onPressed: onGrantPermission,
          child: Text(l10n.permissionDialogGrant),
        )
      ],
    );
  }
}

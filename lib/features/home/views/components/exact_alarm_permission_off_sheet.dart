import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExactAlarmPermissionOffSheet extends StatelessWidget {
  const ExactAlarmPermissionOffSheet({
    super.key,
    required this.onGrantPermission,
    required this.onCancelModal,
  });

  /// What will happen when "Give permission" button is pressed
  final VoidCallback onGrantPermission;

  /// What will happen when "Cancel" button is pressed
  final VoidCallback onCancelModal;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Icon(Icons.notifications_active_outlined, size: 80),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.notifSheetExactAlarmTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.notifSheetExactAlarmDescription,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: onGrantPermission,
            child: Text(l10n.notifSheetExactAlarmPrimaryButton),
          ),
          TextButton(
            onPressed: onCancelModal,
            child: Text(l10n.notifSheetExactAlarmCancel),
          ),
        ],
      ),
    );
  }
}

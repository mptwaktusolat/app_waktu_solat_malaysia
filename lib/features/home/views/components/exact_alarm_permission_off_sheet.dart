import 'package:flutter/material.dart';

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
          const Text(
            'We require one more permission to trigger the notification/azan at the right time',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'This permission is needed to push the notification at the correct time. If you say no, the app might still schedule the notification, but the delivery may be delayed.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: onGrantPermission,
            child: const Text('Grant now'),
          ),
          TextButton(
            onPressed: onCancelModal,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

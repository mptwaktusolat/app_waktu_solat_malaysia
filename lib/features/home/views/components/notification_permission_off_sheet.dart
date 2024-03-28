import 'package:flutter/material.dart';

class NotificationPermissionOffSheet extends StatelessWidget {
  const NotificationPermissionOffSheet({
    super.key,
    required this.onTurnOnNotification,
    required this.onCancelModal,
  });

  /// What will happen when "Turn On Notification" button is pressed
  final VoidCallback onTurnOnNotification;

  /// What will happen when "Keep it off for now" button is pressed
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
            child: Icon(Icons.notifications_off_outlined, size: 80),
          ),
          const SizedBox(height: 8),
          const Text(
            'Notification/Azan is turned off',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'We may require some permissions to be able to play the notification/azan',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: onTurnOnNotification,
            child: const Text('Turn On Notification'),
          ),
          TextButton(
            onPressed: onCancelModal,
            child: const Text('Keep it off for now'),
          ),
        ],
      ),
    );
  }
}

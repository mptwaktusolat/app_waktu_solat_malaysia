import 'package:flutter/material.dart';

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
    return AlertDialog(
      title: const Text('Permission Required'),
      content: Text(
          '$leadingCount) Please grant the app permission to schedule notifications at exact time'),
      actions: [
        TextButton(
          onPressed: onSkip,
          child: const Text('Skip'),
        ),
        TextButton(onPressed: onGrantPermission, child: const Text('Grant'))
      ],
    );
  }
}

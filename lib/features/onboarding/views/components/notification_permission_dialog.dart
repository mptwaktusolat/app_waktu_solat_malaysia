import 'package:flutter/material.dart';

class NotificationPermissionDialog extends StatelessWidget {
  const NotificationPermissionDialog(
      {super.key, required this.leadingCount, required this.onGrantPermission});

  final String leadingCount;
  final VoidCallback onGrantPermission;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Permission Required'),
      content: Text(
          '$leadingCount) Please grant the notification permission to allow this app to show notifications'),
      actions: [
        TextButton(
          onPressed: onGrantPermission,
          child: const Text('Grant'),
        )
      ],
    );
  }
}

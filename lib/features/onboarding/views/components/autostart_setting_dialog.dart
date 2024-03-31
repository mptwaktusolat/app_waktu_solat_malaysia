import 'package:flutter/material.dart';

class AutostartSettingDialog extends StatelessWidget {
  const AutostartSettingDialog({
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
          '$leadingCount) Please allow app to Autostart to keep receive notifications even if the device restarts'),
      actions: [
        TextButton(
          onPressed: onSkip,
          child: const Text('Skip'),
        ),
        TextButton(
          onPressed: onGrantPermission,
          child: const Text('Grant'),
        )
      ],
    );
  }
}

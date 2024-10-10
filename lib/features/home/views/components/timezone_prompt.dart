import 'package:admonitions/admonitions.dart';
import 'package:flutter/material.dart';

class TimezonePrompt extends StatefulWidget {
  const TimezonePrompt({super.key});

  @override
  State<TimezonePrompt> createState() => _TimezonePromptState();
}

class _TimezonePromptState extends State<TimezonePrompt> {
  /// Checks if timezone is following Malaysia time. Return [true] if timezone
  /// is correct, otherwise return [false].
  bool _checkCorrectTimezone() {
    final dateTime = DateTime.now();
    final deviceTimezoneOffset = dateTime.timeZoneOffset;

    if (deviceTimezoneOffset.compareTo(const Duration(hours: 8)) != 0) {
      print('Timezone not same as Malaysia. Offset: $deviceTimezoneOffset');
      return false;
    }

    // Timezone offset is correct
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (_checkCorrectTimezone()) {
      return SizedBox.shrink();
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: PastelAdmonition.caution(
          text:
              'Your device timezone is different than the date & time shown here. Please set your timezone to Malaysia (UTC+08:00).',
        ),
      );
    }
  }
}

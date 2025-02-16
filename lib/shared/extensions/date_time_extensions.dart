import 'package:intl/intl.dart';

extension TimeFormat on DateTime {
  /// Format dateTime
  String readable(bool is12hr) {
    final formatToReadable =
        is12hr ? DateFormat('h:mm a') : DateFormat('HH:mm');
    return formatToReadable.format(this);
  }
}

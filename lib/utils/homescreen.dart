import 'dart:convert';

import 'package:home_widget/home_widget.dart';

/// Homescreen widget utility helper
class Homescreen {
  /// Save the whole month prayer time data as json
  static Future<void> savePrayerDataAndUpdateWidget(
      Map<String, dynamic> json, String widgetTitle) async {
    await HomeWidget.saveWidgetData('prayer_data', jsonEncode(json));
    await HomeWidget.saveWidgetData('widget_title', widgetTitle);
    await HomeWidget.saveWidgetData('last_updated', DateTime.now().toString());

    // Trigger widgets update to show the new data
    await HomeWidget.updateWidget(name: 'SolatHorizontalWidget');

    await HomeWidget.updateWidget(name: 'SolatVerticalWidget');
  }
}

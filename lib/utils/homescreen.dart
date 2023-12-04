import 'package:home_widget/home_widget.dart';

/// Homescreen widget utility helper
class Homescreen {
  /// Update the solat widget with the current prayer time data
  static void updateSolatWidget(
      {required String title,
      required String subuhTime,
      required String zohorTime,
      required String asarTime,
      required String maghribTime,
      required String isyakTime}) async {
    // set the data
    await Future.wait([
      HomeWidget.saveWidgetData('widget_title', title),
      HomeWidget.saveWidgetData('widget_subuh_time', subuhTime),
      HomeWidget.saveWidgetData('widget_zuhur_time', zohorTime),
      HomeWidget.saveWidgetData('widget_asar_time', asarTime),
      HomeWidget.saveWidgetData('widget_maghrib_time', maghribTime),
      HomeWidget.saveWidgetData('widget_isyak_time', isyakTime),
    ]);

    // update the widget based on the set data
    HomeWidget.updateWidget(
      name: 'SolatHorizontalWidget',
      androidName: 'SolatHorizontalWidget',
    );
  }
}

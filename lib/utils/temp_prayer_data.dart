/// This class will be used to hold prayer data so when copy or share is invoked,
/// the data can be accessed immediately
class TempPrayerTimeData {
  static String? subuhTime;
  static String? zohorTime;
  static String? asarTime;
  static String? maghribTime;
  static String? isyaTime;

  /// Returns all (six) prayer time
  static List allPrayerTime() {
    return [subuhTime, zohorTime, asarTime, maghribTime, isyaTime];
  }
}

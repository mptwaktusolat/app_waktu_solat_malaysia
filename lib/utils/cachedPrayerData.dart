class CachedPrayerTimeData {
  static String subuhTime;
  static String zohorTime;
  static String asarTime;
  static String maghribTime;
  static String isyaTime;

  //next time maybe will use local database or something

  static List allPrayerTime() {
    return [subuhTime, zohorTime, asarTime, maghribTime, isyaTime];
  }
}

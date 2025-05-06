class PrayerZoneExceptions implements Exception {
  final String message;
  PrayerZoneExceptions(this.message);

  @override
  String toString() {
    return 'PrayerZoneExceptions: $message';
  }
}

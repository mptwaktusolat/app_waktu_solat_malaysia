/// Convert API model to be custom model
class CustomPrayerTimeModel {
  // all timestamp in epoch millis
  int imsak;
  int subuh;
  int syuruk;
  int dhuha;
  int zohor;
  int asar;
  int maghrib;
  int isyak;

  CustomPrayerTimeModel(
      {this.imsak,
      this.subuh,
      this.syuruk,
      this.dhuha,
      this.zohor,
      this.asar,
      this.isyak,
      this.maghrib});
}

class JakimPrayerModel {
  List<PrayerTime> prayerTime;
  String status;
  String serverTime;
  String periodType;
  String lang;
  String zone;
  String bearing;

  JakimPrayerModel(
      {this.prayerTime,
      this.status,
      this.serverTime,
      this.periodType,
      this.lang,
      this.zone,
      this.bearing});

  JakimPrayerModel.fromJson(Map<String, dynamic> json) {
    if (json['prayerTime'] != null) {
      prayerTime = new List<PrayerTime>.empty(growable: true);
      json['prayerTime'].forEach((v) {
        prayerTime.add(new PrayerTime.fromJson(v));
      });
    }
    status = json['status'];
    serverTime = json['serverTime'];
    periodType = json['periodType'];
    lang = json['lang'];
    zone = json['zone'];
    bearing = json['bearing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.prayerTime != null) {
      data['prayerTime'] = this.prayerTime.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['serverTime'] = this.serverTime;
    data['periodType'] = this.periodType;
    data['lang'] = this.lang;
    data['zone'] = this.zone;
    data['bearing'] = this.bearing;
    return data;
  }
}

class PrayerTime {
  String hijri;
  String date;
  String day;
  String imsak;
  String fajr;
  String syuruk;
  String dhuhr;
  String asr;
  String maghrib;
  String isha;

  PrayerTime(
      {this.hijri,
      this.date,
      this.day,
      this.imsak,
      this.fajr,
      this.syuruk,
      this.dhuhr,
      this.asr,
      this.maghrib,
      this.isha});

  PrayerTime.fromJson(Map<String, dynamic> json) {
    hijri = json['hijri'];
    date = json['date'];
    day = json['day'];
    imsak = json['imsak'];
    fajr = json['fajr'];
    syuruk = json['syuruk'];
    dhuhr = json['dhuhr'];
    asr = json['asr'];
    maghrib = json['maghrib'];
    isha = json['isha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hijri'] = this.hijri;
    data['date'] = this.date;
    data['day'] = this.day;
    data['imsak'] = this.imsak;
    data['fajr'] = this.fajr;
    data['syuruk'] = this.syuruk;
    data['dhuhr'] = this.dhuhr;
    data['asr'] = this.asr;
    data['maghrib'] = this.maghrib;
    data['isha'] = this.isha;
    return data;
  }
}

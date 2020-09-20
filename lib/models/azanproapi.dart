class AzanPro {
  String zone;
  String start;
  String end;
  List<String> locations;
  PrayerTimes prayerTimes;

  AzanPro({this.zone, this.start, this.end, this.locations, this.prayerTimes});

  AzanPro.fromJson(Map<String, dynamic> json) {
    zone = json['zone'];
    start = json['start'];
    end = json['end'];
    locations = json['locations'].cast<String>();
    prayerTimes = json['prayer_times'] != null
        ? new PrayerTimes.fromJson(json['prayer_times'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['zone'] = this.zone;
    data['start'] = this.start;
    data['end'] = this.end;
    data['locations'] = this.locations;
    if (this.prayerTimes != null) {
      data['prayer_times'] = this.prayerTimes.toJson();
    }
    return data;
  }
}

class PrayerTimes {
  String date;
  int datestamp;
  String imsak;
  String subuh;
  String syuruk;
  String zohor;
  String asar;
  String maghrib;
  String isyak;

  PrayerTimes(
      {this.date,
      this.datestamp,
      this.imsak,
      this.subuh,
      this.syuruk,
      this.zohor,
      this.asar,
      this.maghrib,
      this.isyak});

  PrayerTimes.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    datestamp = json['datestamp'];
    imsak = json['imsak'];
    subuh = json['subuh'];
    syuruk = json['syuruk'];
    zohor = json['zohor'];
    asar = json['asar'];
    maghrib = json['maghrib'];
    isyak = json['isyak'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['datestamp'] = this.datestamp;
    data['imsak'] = this.imsak;
    data['subuh'] = this.subuh;
    data['syuruk'] = this.syuruk;
    data['zohor'] = this.zohor;
    data['asar'] = this.asar;
    data['maghrib'] = this.maghrib;
    data['isyak'] = this.isyak;
    return data;
  }
}

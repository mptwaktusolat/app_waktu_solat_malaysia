class WaktuSolatApp {
  bool success;
  Data data;

  WaktuSolatApp({this.success, this.data});

  WaktuSolatApp.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  Zone zone;
  int month;
  int year;
  List<PrayTimes> prayTimes;

  Data({this.zone, this.month, this.year, this.prayTimes});

  Data.fromJson(Map<String, dynamic> json) {
    zone = json['zone'] != null ? new Zone.fromJson(json['zone']) : null;
    month = json['month'];
    year = json['year'];
    if (json['pray_times'] != null) {
      prayTimes = new List<PrayTimes>();
      json['pray_times'].forEach((v) {
        prayTimes.add(new PrayTimes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.zone != null) {
      data['zone'] = this.zone.toJson();
    }
    data['month'] = this.month;
    data['year'] = this.year;
    if (this.prayTimes != null) {
      data['pray_times'] = this.prayTimes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Zone {
  String code;
  String location;
  String state;
  String country;

  Zone({this.code, this.location, this.state, this.country});

  Zone.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    location = json['location'];
    state = json['state'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['location'] = this.location;
    data['state'] = this.state;
    data['country'] = this.country;
    return data;
  }
}

class PrayTimes {
  String hijriDate;
  String date;
  int subuh;
  int imsak;
  int dhuha;
  int syuruk;
  int maghrib;
  int isyak;
  int zohor;
  int asar;

  PrayTimes(
      {this.hijriDate,
      this.date,
      this.subuh,
      this.imsak,
      this.dhuha,
      this.syuruk,
      this.maghrib,
      this.isyak,
      this.zohor,
      this.asar});

  PrayTimes.fromJson(Map<String, dynamic> json) {
    hijriDate = json['hijri_date'];
    date = json['date'];
    subuh = json['subuh'];
    imsak = json['imsak'];
    dhuha = json['dhuha'];
    syuruk = json['syuruk'];
    maghrib = json['maghrib'];
    isyak = json['isyak'];
    zohor = json['zohor'];
    asar = json['asar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hijri_date'] = this.hijriDate;
    data['date'] = this.date;
    data['subuh'] = this.subuh;
    data['imsak'] = this.imsak;
    data['dhuha'] = this.dhuha;
    data['syuruk'] = this.syuruk;
    data['maghrib'] = this.maghrib;
    data['isyak'] = this.isyak;
    data['zohor'] = this.zohor;
    data['asar'] = this.asar;
    return data;
  }
}

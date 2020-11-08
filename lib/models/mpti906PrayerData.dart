class Mpti906PrayerModel {
  Meta meta;
  Data data;

  Mpti906PrayerModel({this.meta, this.data});

  Mpti906PrayerModel.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    data =
        json['response'] != null ? new Data.fromJson(json['response']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    if (this.data != null) {
      data['response'] = this.data.toJson();
    }
    return data;
  }
}

class Meta {
  int code;

  Meta({this.code});

  Meta.fromJson(Map<String, dynamic> json) {
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    return data;
  }
}

class Data {
  String provider;
  String code;
  String origin;
  String jakim;
  List<List> times;

  Data({this.provider, this.code, this.origin, this.jakim, this.times});

  Data.fromJson(Map<String, dynamic> json) {
    provider = json['provider'];
    code = json['code'];
    origin = json['origin'];
    jakim = json['jakim'];
    if (json['times'] != null) {
      times = new List<List>();
      json['times'].forEach((v) {
        times.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['provider'] = this.provider;
    data['code'] = this.code;
    data['origin'] = this.origin;
    data['jakim'] = this.jakim;
    if (this.times != null) {
      data['times'] = this.times.map((v) => v);
    }
    return data;
  }
}

class Times {
  Times.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

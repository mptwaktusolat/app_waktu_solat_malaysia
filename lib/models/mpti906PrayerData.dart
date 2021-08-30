class Mpti906PrayerModel {
  Data? data;

  Mpti906PrayerModel({this.data});

  Mpti906PrayerModel.fromJson(Map<String, dynamic> json) {
    data = json["data"] == null ? null : Data.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data["data"] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? provider;
  String? code;
  int? year;
  int? month;
  String? place;
  Attributes? attributes;
  List<List<dynamic>>? times;

  Data(
      {this.provider,
      this.code,
      this.year,
      this.month,
      this.place,
      this.attributes,
      this.times});

  Data.fromJson(Map<String, dynamic> json) {
    provider = json["provider"];
    code = json["code"];
    year = json["year"];
    month = json["month"];
    place = json["place"];
    attributes = json["attributes"] == null
        ? null
        : Attributes.fromJson(json["attributes"]);
    times =
        json["times"] == null ? null : List<List<dynamic>>.from(json["times"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["provider"] = provider;
    data["code"] = code;
    data["year"] = year;
    data["month"] = month;
    data["place"] = place;
    if (attributes != null) {
      data["attributes"] = attributes!.toJson();
    }
    if (times != null) {
      data["times"] = times;
    }
    return data;
  }
}

class Attributes {
  String? jakimCode;
  String? jakimSource;

  Attributes({this.jakimCode, this.jakimSource});

  Attributes.fromJson(Map<String, dynamic> json) {
    jakimCode = json["jakim_code"];
    jakimSource = json["jakim_source"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["jakim_code"] = jakimCode;
    data["jakim_source"] = jakimSource;
    return data;
  }
}

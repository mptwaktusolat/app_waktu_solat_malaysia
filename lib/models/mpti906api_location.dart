class Mpti906Location {
  Data data;

  Mpti906Location({this.data});

  Mpti906Location.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String provider;
  String code;
  int year;
  int month;
  String place;
  Attributes attributes;

  Data(
      {this.provider,
      this.code,
      this.year,
      this.month,
      this.place,
      this.attributes});

  Data.fromJson(Map<String, dynamic> json) {
    provider = json['provider'];
    code = json['code'];
    year = json['year'];
    month = json['month'];
    place = json['place'];
    attributes = json['attributes'] != null
        ? new Attributes.fromJson(json['attributes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['provider'] = this.provider;
    data['code'] = this.code;
    data['year'] = this.year;
    data['month'] = this.month;
    data['place'] = this.place;
    if (this.attributes != null) {
      data['attributes'] = this.attributes.toJson();
    }
    return data;
  }
}

class Attributes {
  String jakimCode;
  String jakimSource;

  Attributes({this.jakimCode, this.jakimSource});

  Attributes.fromJson(Map<String, dynamic> json) {
    jakimCode = json['jakim_code'];
    jakimSource = json['jakim_source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jakim_code'] = this.jakimCode;
    data['jakim_source'] = this.jakimSource;
    return data;
  }
}

class Mpti906PrayerModel {
  Data data;

  Mpti906PrayerModel({this.data});

  Mpti906PrayerModel.fromJson(Map<String, dynamic> json) {
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
  String times;

  Data({this.times});

  Data.fromJson(Map<String, dynamic> json) {
    times = json['times'].toString(); //force text
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['times'] = this.times;
    return data;
  }
}

//No longer use azanpro api but keep this file in case of emergency
//This file was originally worked with location JSON file but was removed in previous commit.

class GroupedZones {
  String zone;
  String negeri;
  String lokasi;

  GroupedZones({this.zone, this.negeri, this.lokasi});

  GroupedZones.fromJson(Map<String, dynamic> json) {
    zone = json['zone'];
    negeri = json['negeri'];
    lokasi = json['lokasi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['zone'] = this.zone;
    data['negeri'] = this.negeri;
    data['lokasi'] = this.lokasi;
    return data;
  }
}

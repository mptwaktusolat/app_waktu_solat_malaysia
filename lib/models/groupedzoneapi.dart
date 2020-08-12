class GroupedZones {
  List<String> states;
  List<Results> results;

  GroupedZones({this.states, this.results});

  GroupedZones.fromJson(Map<String, dynamic> json) {
    states = json['states'].cast<String>();
    if (json['results'] != null) {
      results = new List<Results>();
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['states'] = this.states;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String zone;
  String negeri;
  String lokasi;

  Results({this.zone, this.negeri, this.lokasi});

  Results.fromJson(Map<String, dynamic> json) {
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

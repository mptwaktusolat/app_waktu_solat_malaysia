class JakimZones {
  late String jakimCode;
  late String negeri;
  late String daerah;

  JakimZones(
      {required this.jakimCode, required this.negeri, required this.daerah});

  JakimZones.fromJson(Map<String, dynamic> json) {
    jakimCode = json["jakimCode"];
    negeri = json["negeri"];
    daerah = json["daerah"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["jakimCode"] = jakimCode;
    data["negeri"] = negeri;
    data["daerah"] = daerah;
    return data;
  }

  @override
  String toString() {
    return 'JakimZones{jakimCode: $jakimCode, negeri: $negeri, daerah: $daerah}';
  }
}

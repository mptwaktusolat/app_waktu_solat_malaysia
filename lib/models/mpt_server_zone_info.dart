class MptServerZoneInfo {
  late String state;
  late String district;
  late String zone;

  MptServerZoneInfo(
      {required this.state, required this.district, required this.zone});

  MptServerZoneInfo.fromJson(Map<String, dynamic> json) {
    state = json["state"];
    district = json["district"];
    zone = json["zone"];
  }

  static List<MptServerZoneInfo> fromList(List<dynamic> list) {
    return list.map((map) => MptServerZoneInfo.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["state"] = state;
    data["district"] = district;
    data["zone"] = zone;
    return data;
  }
}

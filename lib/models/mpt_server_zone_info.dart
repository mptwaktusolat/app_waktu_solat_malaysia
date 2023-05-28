class MptServerZoneInfo {
  late String state;
  late String stateIso;
  late String zone;

  MptServerZoneInfo(
      {required this.state, required this.stateIso, required this.zone});

  MptServerZoneInfo.fromJson(Map<String, dynamic> json) {
    state = json["state"];
    stateIso = json["state_iso"];
    zone = json["zone"];
  }

  static List<MptServerZoneInfo> fromList(List<dynamic> list) {
    return list.map((map) => MptServerZoneInfo.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["state"] = state;
    data["state_iso"] = stateIso;
    data["zone"] = zone;
    return data;
  }
}

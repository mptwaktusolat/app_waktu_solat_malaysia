/// Zones Info model from WaktuSolat API
class ZonesInfo {
  /// State name (negeri)
  late String state;

  /// Zones name
  late String district;

  /// JAKIM code (eg: SGR01)
  late String zone;

  ZonesInfo({required this.state, required this.district, required this.zone});

  ZonesInfo.fromJson(Map<String, dynamic> json) {
    state = json["state"];
    district = json["district"];
    zone = json["zone"];
  }

  static List<ZonesInfo> fromList(List<dynamic> list) {
    return list.map((map) => ZonesInfo.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["state"] = state;
    data["district"] = district;
    data["zone"] = zone;
    return data;
  }
}

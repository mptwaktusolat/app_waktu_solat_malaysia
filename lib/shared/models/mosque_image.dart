/// Background images for prayer timetable
/// https://waktusolat.iqfareez.com/mosques
class MosqueImage {
  late String zone;
  late String imgUrl;

  MosqueImage({required this.zone, required this.imgUrl});

  MosqueImage.fromJson(Map<String, dynamic> json) {
    zone = json["zone"];
    imgUrl = json["imgUrl"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["zone"] = zone;
    data["imgUrl"] = imgUrl;
    return data;
  }
}

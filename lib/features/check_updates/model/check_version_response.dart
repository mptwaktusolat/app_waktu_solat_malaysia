/// Response model for https://waktusolat.app/api/check_version
class CheckVersionResponse {
  /// GitHub release tag
  late String tag;

  /// GitHub release title
  late String releaseTitle;

  /// App version (first part of tag split by `+`)
  late String version;

  /// App build number (second part of tag split by `+`)
  late int buildNumber;

  /// GitHub release published date
  late DateTime publishedAt;

  CheckVersionResponse({
    required this.tag,
    required this.releaseTitle,
    required this.version,
    required this.buildNumber,
    required this.publishedAt,
  });

  CheckVersionResponse.fromJson(Map<String, dynamic> json) {
    tag = json["tag"];
    releaseTitle = json["releaseTitle"];
    version = json["version"];
    buildNumber = json["buildNumber"];
    publishedAt = DateTime.parse(json["publishedAt"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["tag"] = tag;
    data["releaseTitle"] = releaseTitle;
    data["version"] = version;
    data["buildNumber"] = buildNumber;
    data["publishedAt"] = publishedAt;
    return data;
  }
}

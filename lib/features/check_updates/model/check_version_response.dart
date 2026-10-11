import 'package:json_annotation/json_annotation.dart';

part 'check_version_response.g.dart';

/// Response model for https://waktusolat.app/check_version.json
@JsonSerializable(explicitToJson: true)
class CheckVersionResponse {
  @JsonKey(name: 'android')
  final AndroidVersionResponse android;

  CheckVersionResponse({required this.android});

  factory CheckVersionResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckVersionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckVersionResponseToJson(this);

  @override
  String toString() {
    return 'CheckVersionResponse{android: $android}';
  }
}

@JsonSerializable()
class AndroidVersionResponse {
  /// GitHub release tag
  final String tag;

  /// GitHub release title
  final String releaseTitle;

  /// App version (first part of tag split by `+`)
  final String version;

  /// App build number (second part of tag split by `+`)
  final int buildNumber;

  /// GitHub release published date
  final DateTime publishedAt;

  AndroidVersionResponse({
    required this.tag,
    required this.releaseTitle,
    required this.version,
    required this.buildNumber,
    required this.publishedAt,
  });

  factory AndroidVersionResponse.fromJson(Map<String, dynamic> json) =>
      _$AndroidVersionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AndroidVersionResponseToJson(this);

  @override
  String toString() {
    return 'AndroidVersionResponse{tag: $tag, releaseTitle: $releaseTitle, version: $version, buildNumber: $buildNumber, publishedAt: $publishedAt}';
  }
}

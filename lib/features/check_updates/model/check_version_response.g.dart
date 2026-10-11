// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_version_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckVersionResponse _$CheckVersionResponseFromJson(
  Map<String, dynamic> json,
) => CheckVersionResponse(
  android: AndroidVersionResponse.fromJson(
    json['android'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$CheckVersionResponseToJson(
  CheckVersionResponse instance,
) => <String, dynamic>{'android': instance.android.toJson()};

AndroidVersionResponse _$AndroidVersionResponseFromJson(
  Map<String, dynamic> json,
) => AndroidVersionResponse(
  tag: json['tag'] as String,
  releaseTitle: json['releaseTitle'] as String,
  version: json['version'] as String,
  buildNumber: (json['buildNumber'] as num).toInt(),
  publishedAt: DateTime.parse(json['publishedAt'] as String),
);

Map<String, dynamic> _$AndroidVersionResponseToJson(
  AndroidVersionResponse instance,
) => <String, dynamic>{
  'tag': instance.tag,
  'releaseTitle': instance.releaseTitle,
  'version': instance.version,
  'buildNumber': instance.buildNumber,
  'publishedAt': instance.publishedAt.toIso8601String(),
};

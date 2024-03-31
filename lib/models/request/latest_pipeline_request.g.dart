// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latest_pipeline_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatestPipelineRequest _$LatestPipelineRequestFromJson(
        Map<String, dynamic> json) =>
    LatestPipelineRequest(
      ref: json['ref'] as String?,
    );

Map<String, dynamic> _$LatestPipelineRequestToJson(
    LatestPipelineRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('ref', instance.ref);
  return val;
}

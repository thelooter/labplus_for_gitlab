// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pipeline_jobs_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListPipelineJobsRequest _$ListPipelineJobsRequestFromJson(
        Map<String, dynamic> json) =>
    ListPipelineJobsRequest(
      json['scope'] as String?,
      json['include_retried'] as bool?,
    );

Map<String, dynamic> _$ListPipelineJobsRequestToJson(
        ListPipelineJobsRequest instance) =>
    <String, dynamic>{
      'scope': instance.scope,
      'include_retried': instance.includeRetried,
    };

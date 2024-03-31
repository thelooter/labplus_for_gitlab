// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pipeline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pipeline _$PipelineFromJson(Map<String, dynamic> json) => Pipeline(
      id: json['id'] as int?,
      iid: json['iid'] as int?,
      projectId: json['project_id'] as int?,
      sha: json['sha'] as String?,
      ref: json['ref'] as String?,
      status: json['status'] as String?,
      source: json['source'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      webUrl: json['web_url'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$PipelineToJson(Pipeline instance) => <String, dynamic>{
      'id': instance.id,
      'iid': instance.iid,
      'project_id': instance.projectId,
      'sha': instance.sha,
      'ref': instance.ref,
      'status': instance.status,
      'source': instance.source,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'web_url': instance.webUrl,
      'name': instance.name,
    };

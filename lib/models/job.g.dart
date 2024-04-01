// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Job _$JobFromJson(Map<String, dynamic> json) => Job(
      json['commit'] == null
          ? null
          : Commit.fromJson(json['commit'] as Map<String, dynamic>),
      (json['coverage'] as num?)?.toDouble(),
      json['archived'] as bool?,
      json['allow_failure'] as bool?,
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      json['started_at'] == null
          ? null
          : DateTime.parse(json['started_at'] as String),
      json['finished_at'] == null
          ? null
          : DateTime.parse(json['finished_at'] as String),
      json['erased_at'] == null
          ? null
          : DateTime.parse(json['erased_at'] as String),
      (json['duration'] as num?)?.toDouble(),
      (json['queued_duration'] as num?)?.toDouble(),
      json['artifacts_file'] == null
          ? null
          : ArtifactsFile.fromJson(
              json['artifacts_file'] as Map<String, dynamic>),
      (json['artifacts'] as List<dynamic>?)
          ?.map((e) => Artifact.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['artifacts_expire_at'] as String?,
      (json['tag_list'] as List<dynamic>?)?.map((e) => e as String).toList(),
      json['id'] as int?,
      json['name'] as String?,
      json['pipeline'] == null
          ? null
          : Pipeline.fromJson(json['pipeline'] as Map<String, dynamic>),
      json['ref'] as String?,
      json['runner'] == null
          ? null
          : Runner.fromJson(json['runner'] as Map<String, dynamic>),
      json['stage'] as String?,
      json['status'] as String?,
      json['failure_reason'] as String?,
      json['tag'] as bool?,
      json['web_url'] as String?,
      json['project'] == null
          ? null
          : Project.fromJson(json['project'] as Map<String, dynamic>),
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JobToJson(Job instance) => <String, dynamic>{
      'commit': instance.commit,
      'coverage': instance.coverage,
      'archived': instance.archived,
      'allow_failure': instance.allowFailure,
      'created_at': instance.createdAt?.toIso8601String(),
      'started_at': instance.startedAt?.toIso8601String(),
      'finished_at': instance.finishedAt?.toIso8601String(),
      'erased_at': instance.erasedAt?.toIso8601String(),
      'duration': instance.duration,
      'queued_duration': instance.queuedDuration,
      'artifacts_file': instance.artifactsFile,
      'artifacts': instance.artifacts,
      'artifacts_expire_at': instance.artifactsExpireAt,
      'tag_list': instance.tagList,
      'id': instance.id,
      'name': instance.name,
      'pipeline': instance.pipeline,
      'ref': instance.ref,
      'runner': instance.runner,
      'stage': instance.stage,
      'status': instance.status,
      'failure_reason': instance.failureReason,
      'tag': instance.tag,
      'web_url': instance.webUrl,
      'project': instance.project,
      'user': instance.user,
    };

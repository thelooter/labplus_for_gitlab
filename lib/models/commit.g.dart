// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Commit _$CommitFromJson(Map<String, dynamic> json) => Commit(
      id: json['id'] as String?,
      shortId: json['short_id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      parentIds: (json['parent_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      title: json['title'] as String?,
      message: json['message'] as String?,
      authorName: json['author_name'] as String?,
      authorEmail: json['author_email'] as String?,
      authoredDate: json['authored_date'] == null
          ? null
          : DateTime.parse(json['authored_date'] as String),
      committerName: json['committer_name'] as String?,
      committerEmail: json['committer_email'] as String?,
      committedDate: json['committed_date'] == null
          ? null
          : DateTime.parse(json['committed_date'] as String),
      webUrl: json['web_url'] as String?,
      stats: json['stats'] == null
          ? null
          : CommitStats.fromJson(json['stats'] as Map<String, dynamic>),
      lastPipeline: json['last_pipeline'] == null
          ? null
          : Pipeline.fromJson(json['last_pipeline'] as Map<String, dynamic>),
      status: json['status'] as String?,
      sha: json['sha'] as String?,
    );

Map<String, dynamic> _$CommitToJson(Commit instance) => <String, dynamic>{
      'id': instance.id,
      'short_id': instance.shortId,
      'title': instance.title,
      'author_name': instance.authorName,
      'author_email': instance.authorEmail,
      'committer_name': instance.committerName,
      'committer_email': instance.committerEmail,
      'created_at': instance.createdAt?.toIso8601String(),
      'message': instance.message,
      'committed_date': instance.committedDate?.toIso8601String(),
      'authored_date': instance.authoredDate?.toIso8601String(),
      'parent_ids': instance.parentIds,
      'web_url': instance.webUrl,
      'last_pipeline': instance.lastPipeline,
      'stats': instance.stats,
      'status': instance.status,
      'sha': instance.sha,
    };

import 'package:json_annotation/json_annotation.dart';

import 'models.dart';

part 'job.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Job {
  final Commit? commit;
  final double? coverage;
  final bool? archived;
  final bool? allowFailure;
  final DateTime? createdAt;
  final DateTime? startedAt;
  final DateTime? finishedAt;
  final DateTime? erasedAt;
  final double? duration;
  final double? queuedDuration;
  final ArtifactsFile? artifactsFile;
  final List<Artifact>? artifacts;
  final String? artifactsExpireAt;
  final List<String>? tagList;
  final int? id;
  final String? name;
  final Pipeline? pipeline;
  final String? ref;
  final Runner? runner;
  final String? stage;
  final String? status;
  final String? failureReason;
  final bool? tag;
  final String? webUrl;
  final Project? project;
  final User? user;

  Job(
    this.commit,
    this.coverage,
    this.archived,
    this.allowFailure,
    this.createdAt,
    this.startedAt,
    this.finishedAt,
    this.erasedAt,
    this.duration,
    this.queuedDuration,
    this.artifactsFile,
    this.artifacts,
    this.artifactsExpireAt,
    this.tagList,
    this.id,
    this.name,
    this.pipeline,
    this.ref,
    this.runner,
    this.stage,
    this.status,
    this.failureReason,
    this.tag,
    this.webUrl,
    this.project,
    this.user,
  );

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);

  Map<String, dynamic> toJson() => _$JobToJson(this);
}

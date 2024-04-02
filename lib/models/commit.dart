import 'package:labplus_for_gitlab/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'commit.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Commit {
  final String? id;
  final String? shortId;
  final String? title;
  final String? authorName;
  final String? authorEmail;
  final String? committerName;
  final String? committerEmail;
  final DateTime? createdAt;
  final String? message;
  final DateTime? committedDate;
  final DateTime? authoredDate;
  final List<String>? parentIds;
  final String? webUrl;
  final Pipeline? lastPipeline;
  final CommitStats? stats;
  final String? status;
  final String? sha;

  Commit({
    this.id,
    this.shortId,
    this.createdAt,
    this.parentIds,
    this.title,
    this.message,
    this.authorName,
    this.authorEmail,
    this.authoredDate,
    this.committerName,
    this.committerEmail,
    this.committedDate,
    this.webUrl,
    this.stats,
    this.lastPipeline,
    this.status,
    this.sha,
  });

  factory Commit.fromJson(Map<String, dynamic> json) => _$CommitFromJson(json);

  Map<String, dynamic> toJson() => _$CommitToJson(this);
}

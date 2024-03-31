import 'package:json_annotation/json_annotation.dart';

part 'pipeline.g.dart';

//TODO: Figure out how to actually get the pipeline data

@JsonSerializable(fieldRename: FieldRename.snake)
class Pipeline {
  final int? id;
  final int? iid;
  final int? projectId;
  final String? sha;
  final String? ref;
  final String? status;
  final String? source;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? webUrl;
  final String? name;

  Pipeline({
    this.id,
    this.iid,
    this.projectId,
    this.sha,
    this.ref,
    this.status,
    this.source,
    this.createdAt,
    this.updatedAt,
    this.webUrl,
    this.name,
  });

  factory Pipeline.fromJson(Map<String, dynamic> json) =>
      _$PipelineFromJson(json);

  Map<String, dynamic> toJson() => _$PipelineToJson(this);
}

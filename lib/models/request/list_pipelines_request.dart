
import 'package:json_annotation/json_annotation.dart';

part 'list_pipelines_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ListPipelinesRequest {
  final int? perPage;
  final int? page;
  final String? name;
  final String? orderBy;
  final String? ref;
  final String? scope;
  final String? source;
  final String? status;
  final DateTime? updatedAfter;
  final DateTime? updatedBefore;
  final String? username;
  final bool? yamlErrors;

  ListPipelinesRequest({
    this.perPage,
    this.page,
    this.name,
    this.orderBy,
    this.ref,
    this.scope,
    this.source,
    this.status,
    this.updatedAfter,
    this.updatedBefore,
    this.username,
    this.yamlErrors,
  });

  factory ListPipelinesRequest.fromJson(Map<String, dynamic> json) =>
      _$ListPipelinesRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ListPipelinesRequestToJson(this);
}
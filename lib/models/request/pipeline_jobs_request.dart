import 'package:json_annotation/json_annotation.dart';

part 'pipeline_jobs_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ListPipelineJobsRequest {
  final String? scope;
  final bool? includeRetried;

  ListPipelineJobsRequest(this.scope, this.includeRetried);

  factory ListPipelineJobsRequest.fromJson(Map<String, dynamic> json) =>
      _$ListPipelineJobsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ListPipelineJobsRequestToJson(this);
}
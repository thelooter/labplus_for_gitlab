import 'package:json_annotation/json_annotation.dart';

part 'jobs_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ListProjectJobsRequest {
  final String? scope;

  ListProjectJobsRequest(this.scope);

  factory ListProjectJobsRequest.fromJson(Map<String, dynamic> json) =>
      _$ListProjectJobsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ListProjectJobsRequestToJson(this);
}
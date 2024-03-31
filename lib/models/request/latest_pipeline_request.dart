import 'package:json_annotation/json_annotation.dart';

part 'latest_pipeline_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class LatestPipelineRequest {
  final String? ref;

  LatestPipelineRequest({this.ref});

  factory LatestPipelineRequest.fromJson(Map<String, dynamic> json) =>
      _$LatestPipelineRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LatestPipelineRequestToJson(this);
}

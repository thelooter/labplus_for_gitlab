
import 'package:json_annotation/json_annotation.dart';

part 'artifacts_file.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ArtifactsFile {
  final String? filename;
  final int? size;

  ArtifactsFile(this.filename, this.size);

  factory ArtifactsFile.fromJson(Map<String, dynamic> json) => _$ArtifactsFileFromJson(json);

  Map<String, dynamic> toJson() => _$ArtifactsFileToJson(this);
}
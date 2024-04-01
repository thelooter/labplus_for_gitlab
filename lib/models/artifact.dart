import 'package:json_annotation/json_annotation.dart';

part 'artifact.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Artifact {
  final String? fileType;
  final int? size;
  final String? filename;
  final String? fileFormat;

  Artifact(
    this.fileType,
    this.size,
    this.filename,
    this.fileFormat,
  );

  factory Artifact.fromJson(Map<String, dynamic> json) => _$ArtifactFromJson(json);

  Map<String, dynamic> toJson() => _$ArtifactToJson(this);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artifact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Artifact _$ArtifactFromJson(Map<String, dynamic> json) => Artifact(
      json['file_type'] as String?,
      json['size'] as int?,
      json['filename'] as String?,
      json['file_format'] as String?,
    );

Map<String, dynamic> _$ArtifactToJson(Artifact instance) => <String, dynamic>{
      'file_type': instance.fileType,
      'size': instance.size,
      'filename': instance.filename,
      'file_format': instance.fileFormat,
    };

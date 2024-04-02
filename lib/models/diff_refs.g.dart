// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diff_refs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiffRefs _$DiffRefsFromJson(Map<String, dynamic> json) => DiffRefs(
      baseSha: json['base_sha'] as String?,
      headSha: json['head_sha'] as String?,
      startSha: json['start_sha'] as String?,
    );

Map<String, dynamic> _$DiffRefsToJson(DiffRefs instance) => <String, dynamic>{
      'base_sha': instance.baseSha,
      'head_sha': instance.headSha,
      'start_sha': instance.startSha,
    };

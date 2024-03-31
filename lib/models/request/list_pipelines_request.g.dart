// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_pipelines_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListPipelinesRequest _$ListPipelinesRequestFromJson(
        Map<String, dynamic> json) =>
    ListPipelinesRequest(
      perPage: json['per_page'] as int?,
      page: json['page'] as int?,
      name: json['name'] as String?,
      orderBy: json['order_by'] as String?,
      ref: json['ref'] as String?,
      scope: json['scope'] as String?,
      source: json['source'] as String?,
      status: json['status'] as String?,
      updatedAfter: json['updated_after'] == null
          ? null
          : DateTime.parse(json['updated_after'] as String),
      updatedBefore: json['updated_before'] == null
          ? null
          : DateTime.parse(json['updated_before'] as String),
      username: json['username'] as String?,
      yamlErrors: json['yaml_errors'] as bool?,
    );

Map<String, dynamic> _$ListPipelinesRequestToJson(
    ListPipelinesRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('per_page', instance.perPage);
  writeNotNull('page', instance.page);
  writeNotNull('name', instance.name);
  writeNotNull('order_by', instance.orderBy);
  writeNotNull('ref', instance.ref);
  writeNotNull('scope', instance.scope);
  writeNotNull('source', instance.source);
  writeNotNull('status', instance.status);
  writeNotNull('updated_after', instance.updatedAfter?.toIso8601String());
  writeNotNull('updated_before', instance.updatedBefore?.toIso8601String());
  writeNotNull('username', instance.username);
  writeNotNull('yaml_errors', instance.yamlErrors);
  return val;
}

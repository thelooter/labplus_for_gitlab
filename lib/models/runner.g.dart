// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'runner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Runner _$RunnerFromJson(Map<String, dynamic> json) => Runner(
      json['id'] as int?,
      json['description'] as String?,
      json['ip_address'] as String?,
      json['active'] as bool?,
      json['paused'] as bool?,
      json['is_shared'] as bool?,
      json['runner_type'] as String?,
      json['name'] as String?,
      json['online'] as bool?,
      json['status'] as String?,
    );

Map<String, dynamic> _$RunnerToJson(Runner instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'ip_address': instance.ipAddress,
      'active': instance.active,
      'paused': instance.paused,
      'is_shared': instance.isShared,
      'runner_type': instance.runnerType,
      'name': instance.name,
      'online': instance.online,
      'status': instance.status,
    };

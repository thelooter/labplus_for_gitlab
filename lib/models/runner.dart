import 'package:json_annotation/json_annotation.dart';

part 'runner.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Runner {
  final int? id;
  final String? description;
  final String? ipAddress;
  final bool? active;
  final bool? paused;
  final bool? isShared;
  final String? runnerType;
  final String? name;
  final bool? online;
  final String? status;

  Runner(
    this.id,
    this.description,
    this.ipAddress,
    this.active,
    this.paused,
    this.isShared,
    this.runnerType,
    this.name,
    this.online,
    this.status,
  );

  factory Runner.fromJson(Map<String, dynamic> json) => _$RunnerFromJson(json);

  Map<String, dynamic> toJson() => _$RunnerToJson(this);
}

import 'package:labplus_for_gitlab/shared/data/secure_storage.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:get/get.dart';

import 'models.dart';

part 'project.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Project {
  final int? id;
  final String? description;
  final String? name;
  final String? nameWithNamespace;
  final String? path;
  final String? pathWithNamespace;
  final String? defaultBranch;
  final String? webUrl;
  final String? readmeUrl;
  final String? avatarUrl;
  final int? forksCount;
  final int? starCount;
  final String? visibility; // GitLabVisibility
  final DateTime? createdAt;
  final DateTime? lastActivityAt;
  final ProjectNamespace? namespace;
  final ProjectPermissions? permissions;

  Project({
    this.id,
    this.description,
    this.name,
    this.nameWithNamespace,
    this.path,
    this.pathWithNamespace,
    this.defaultBranch,
    this.webUrl,
    this.readmeUrl,
    this.avatarUrl,
    this.forksCount,
    this.starCount,
    this.visibility,
    this.createdAt,
    this.lastActivityAt,
    this.namespace,
    this.permissions,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    //rewrite avatar if it is not null
    if (json['avatar_url'] != null) {
      json['avatar_url'] =
          "${Get.find<SecureStorage>().getBaseurl()}/api/v4/projects/${json['id']}/avatar";
    }
    return _$ProjectFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}

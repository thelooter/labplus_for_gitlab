
import 'package:json_annotation/json_annotation.dart';

part 'diff_refs.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DiffRefs {
  final String? baseSha;
  final String? headSha;
  final String? startSha;

  DiffRefs({
    this.baseSha,
    this.headSha,
    this.startSha,
  });

  factory DiffRefs.fromJson(Map<String, dynamic> json) => _$DiffRefsFromJson(json);

  Map<String, dynamic> toJson() => _$DiffRefsToJson(this);
}

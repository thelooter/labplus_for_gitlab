import 'package:labplus_for_gitlab/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detailed_merge_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DetailedMergeRequest {
  final int? id;
  final int? iid;
  final int? projectId;
  final String? title;
  final String? description;
  final String? state; // MergeRequestState
  final Author? mergeUser;
  final DateTime? mergedAt;
  final DateTime? preparedAt;
  final Author? closedBy;
  final DateTime? closedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? targetBranch;
  final String? sourceBranch;
  final int? userNotesCount;
  final int? upvotes;
  final int? downvotes;
  final Author? author;
  final Author? assignee;
  final List<Author>? assignees;
  final List<Author>? reviewers;
  final int? sourceProjectId;
  final int? targetProjectId;
  final List<String>? labels;
  final bool? draft;
  final bool? workInProgress;
  final Milestone? milestone;
  final bool? mergeWhenPipelineSucceeds;
  final String? mergeStatus;
  final String? sha;
  final String? mergeCommitSha;
  final String? squashCommitSha;
  final bool? discussionLocked;
  final bool? shouldRemoveSourceBranch;
  final bool? forceRemoveSourceBranch;
  final String? webUrl;
  final References? references;
  final TimeStats? timeStats;
  final bool? squash;
  final TaskCompletionStatus? taskCompletionStatus;
  final bool? hasConflicts;
  final bool? blockingDiscussionsResolved;
  final bool? subscribed;
  final String? changesCount;
  final DateTime? latestBuildStartedAt;
  final DateTime? latestBuildFinishedAt;
  final DateTime? firstDeployedToProductionAt;
  final Pipeline? headPipeline;
  final DiffRefs? diffRefs;
  final String? mergeError;
  final bool? firstContribution;

  DetailedMergeRequest({
    this.id,
    this.iid,
    this.projectId,
    this.title,
    this.description,
    this.state,
    this.mergeUser,
    this.mergedAt,
    this.preparedAt,
    this.closedBy,
    this.closedAt,
    this.createdAt,
    this.updatedAt,
    this.targetBranch,
    this.sourceBranch,
    this.upvotes,
    this.downvotes,
    this.author,
    this.assignee,
    this.assignees,
    this.reviewers,
    this.sourceProjectId,
    this.targetProjectId,
    this.labels,
    this.draft,
    this.workInProgress,
    this.milestone,
    this.mergeWhenPipelineSucceeds,
    this.mergeStatus,
    this.sha,
    this.mergeCommitSha,
    this.squashCommitSha,
    this.userNotesCount,
    this.discussionLocked,
    this.shouldRemoveSourceBranch,
    this.forceRemoveSourceBranch,
    this.webUrl,
    this.references,
    this.timeStats,
    this.squash,
    this.taskCompletionStatus,
    this.hasConflicts,
    this.blockingDiscussionsResolved,
    this.subscribed,
    this.changesCount,
    this.latestBuildStartedAt,
    this.latestBuildFinishedAt,
    this.firstDeployedToProductionAt,
    this.headPipeline,
    this.diffRefs,
    this.mergeError,
    this.firstContribution,
  });

  factory DetailedMergeRequest.fromJson(Map<String, dynamic> json) =>
      _$DetailedMergeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DetailedMergeRequestToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MergeRequestUser {
  final bool? canMerge;

  MergeRequestUser({this.canMerge});

  factory MergeRequestUser.fromJson(Map<String, dynamic> json) =>
      _$MergeRequestUserFromJson(json);

  Map<String, dynamic> toJson() => _$MergeRequestUserToJson(this);
}
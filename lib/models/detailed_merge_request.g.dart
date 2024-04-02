// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detailed_merge_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailedMergeRequest _$DetailedMergeRequestFromJson(
        Map<String, dynamic> json) =>
    DetailedMergeRequest(
      id: json['id'] as int?,
      iid: json['iid'] as int?,
      projectId: json['project_id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      state: json['state'] as String?,
      mergeUser: json['merge_user'] == null
          ? null
          : Author.fromJson(json['merge_user'] as Map<String, dynamic>),
      mergedAt: json['merged_at'] == null
          ? null
          : DateTime.parse(json['merged_at'] as String),
      preparedAt: json['prepared_at'] == null
          ? null
          : DateTime.parse(json['prepared_at'] as String),
      closedBy: json['closed_by'] == null
          ? null
          : Author.fromJson(json['closed_by'] as Map<String, dynamic>),
      closedAt: json['closed_at'] == null
          ? null
          : DateTime.parse(json['closed_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      targetBranch: json['target_branch'] as String?,
      sourceBranch: json['source_branch'] as String?,
      upvotes: json['upvotes'] as int?,
      downvotes: json['downvotes'] as int?,
      author: json['author'] == null
          ? null
          : Author.fromJson(json['author'] as Map<String, dynamic>),
      assignee: json['assignee'] == null
          ? null
          : Author.fromJson(json['assignee'] as Map<String, dynamic>),
      assignees: (json['assignees'] as List<dynamic>?)
          ?.map((e) => Author.fromJson(e as Map<String, dynamic>))
          .toList(),
      reviewers: (json['reviewers'] as List<dynamic>?)
          ?.map((e) => Author.fromJson(e as Map<String, dynamic>))
          .toList(),
      sourceProjectId: json['source_project_id'] as int?,
      targetProjectId: json['target_project_id'] as int?,
      labels:
          (json['labels'] as List<dynamic>?)?.map((e) => e as String).toList(),
      draft: json['draft'] as bool?,
      workInProgress: json['work_in_progress'] as bool?,
      milestone: json['milestone'] == null
          ? null
          : Milestone.fromJson(json['milestone'] as Map<String, dynamic>),
      mergeWhenPipelineSucceeds: json['merge_when_pipeline_succeeds'] as bool?,
      mergeStatus: json['merge_status'] as String?,
      sha: json['sha'] as String?,
      mergeCommitSha: json['merge_commit_sha'] as String?,
      squashCommitSha: json['squash_commit_sha'] as String?,
      userNotesCount: json['user_notes_count'] as int?,
      discussionLocked: json['discussion_locked'] as bool?,
      shouldRemoveSourceBranch: json['should_remove_source_branch'] as bool?,
      forceRemoveSourceBranch: json['force_remove_source_branch'] as bool?,
      webUrl: json['web_url'] as String?,
      references: json['references'] == null
          ? null
          : References.fromJson(json['references'] as Map<String, dynamic>),
      timeStats: json['time_stats'] == null
          ? null
          : TimeStats.fromJson(json['time_stats'] as Map<String, dynamic>),
      squash: json['squash'] as bool?,
      taskCompletionStatus: json['task_completion_status'] == null
          ? null
          : TaskCompletionStatus.fromJson(
              json['task_completion_status'] as Map<String, dynamic>),
      hasConflicts: json['has_conflicts'] as bool?,
      blockingDiscussionsResolved:
          json['blocking_discussions_resolved'] as bool?,
      subscribed: json['subscribed'] as bool?,
      changesCount: json['changes_count'] as String?,
      latestBuildStartedAt: json['latest_build_started_at'] == null
          ? null
          : DateTime.parse(json['latest_build_started_at'] as String),
      latestBuildFinishedAt: json['latest_build_finished_at'] == null
          ? null
          : DateTime.parse(json['latest_build_finished_at'] as String),
      firstDeployedToProductionAt: json['first_deployed_to_production_at'] ==
              null
          ? null
          : DateTime.parse(json['first_deployed_to_production_at'] as String),
      headPipeline: json['head_pipeline'] == null
          ? null
          : Pipeline.fromJson(json['head_pipeline'] as Map<String, dynamic>),
      diffRefs: json['diff_refs'] == null
          ? null
          : DiffRefs.fromJson(json['diff_refs'] as Map<String, dynamic>),
      mergeError: json['merge_error'] as String?,
      firstContribution: json['first_contribution'] as bool?,
    );

Map<String, dynamic> _$DetailedMergeRequestToJson(
        DetailedMergeRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'iid': instance.iid,
      'project_id': instance.projectId,
      'title': instance.title,
      'description': instance.description,
      'state': instance.state,
      'merge_user': instance.mergeUser,
      'merged_at': instance.mergedAt?.toIso8601String(),
      'prepared_at': instance.preparedAt?.toIso8601String(),
      'closed_by': instance.closedBy,
      'closed_at': instance.closedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'target_branch': instance.targetBranch,
      'source_branch': instance.sourceBranch,
      'user_notes_count': instance.userNotesCount,
      'upvotes': instance.upvotes,
      'downvotes': instance.downvotes,
      'author': instance.author,
      'assignee': instance.assignee,
      'assignees': instance.assignees,
      'reviewers': instance.reviewers,
      'source_project_id': instance.sourceProjectId,
      'target_project_id': instance.targetProjectId,
      'labels': instance.labels,
      'draft': instance.draft,
      'work_in_progress': instance.workInProgress,
      'milestone': instance.milestone,
      'merge_when_pipeline_succeeds': instance.mergeWhenPipelineSucceeds,
      'merge_status': instance.mergeStatus,
      'sha': instance.sha,
      'merge_commit_sha': instance.mergeCommitSha,
      'squash_commit_sha': instance.squashCommitSha,
      'discussion_locked': instance.discussionLocked,
      'should_remove_source_branch': instance.shouldRemoveSourceBranch,
      'force_remove_source_branch': instance.forceRemoveSourceBranch,
      'web_url': instance.webUrl,
      'references': instance.references,
      'time_stats': instance.timeStats,
      'squash': instance.squash,
      'task_completion_status': instance.taskCompletionStatus,
      'has_conflicts': instance.hasConflicts,
      'blocking_discussions_resolved': instance.blockingDiscussionsResolved,
      'subscribed': instance.subscribed,
      'changes_count': instance.changesCount,
      'latest_build_started_at':
          instance.latestBuildStartedAt?.toIso8601String(),
      'latest_build_finished_at':
          instance.latestBuildFinishedAt?.toIso8601String(),
      'first_deployed_to_production_at':
          instance.firstDeployedToProductionAt?.toIso8601String(),
      'head_pipeline': instance.headPipeline,
      'diff_refs': instance.diffRefs,
      'merge_error': instance.mergeError,
      'first_contribution': instance.firstContribution,
    };

MergeRequestUser _$MergeRequestUserFromJson(Map<String, dynamic> json) =>
    MergeRequestUser(
      canMerge: json['can_merge'] as bool?,
    );

Map<String, dynamic> _$MergeRequestUserToJson(MergeRequestUser instance) =>
    <String, dynamic>{
      'can_merge': instance.canMerge,
    };

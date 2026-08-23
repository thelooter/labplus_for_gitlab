import 'package:labplus_for_gitlab/models/models.dart';

/// What the issue routes are about, passed as `Get.toNamed(..., arguments:)`.
///
/// This used to be two mutable fields on the global `Repository` —
/// `issueIid` and `projectId` — that callers wrote *before* navigating.
/// Controllers then read `repository.issue.value.iid ?? repository.issueIid`,
/// so which issue a screen showed depended on the order things happened to
/// have run in, and the values survived after you left the screen.
///
/// Bindings must capture this at `dependencies()` time rather than inside the
/// `lazyPut` closure: those are registered with `fenix: true`, so the closure
/// can run again long after the route changed, and would read whatever
/// `Get.arguments` held by then.
class IssueArgs {
  const IssueArgs({
    required this.projectId,
    required this.issueIid,
    this.issue,
  });

  final int projectId;

  final int issueIid;

  /// The issue the caller already had, if any, so the screen can paint
  /// immediately rather than flashing empty while it refetches. Callers that
  /// only know the iid — the activity feed, for one — leave this null.
  final Issue? issue;

  IssueArgs copyWith({Issue? issue}) => IssueArgs(
        projectId: projectId,
        issueIid: issueIid,
        issue: issue ?? this.issue,
      );

  @override
  String toString() => 'IssueArgs(projectId: $projectId, issueIid: $issueIid)';
}

/// What the merge request routes are about.
///
/// Same story as [IssueArgs]: `mergeRequestIid` was a route parameter living
/// on the global `Repository`, written just before navigating and read back as
/// `repository.mergeRequest.value.iid ?? repository.mergeRequestIid`.
class MergeRequestArgs {
  const MergeRequestArgs({
    required this.projectId,
    required this.mergeRequestIid,
    this.mergeRequest,
  });

  final int projectId;

  final int mergeRequestIid;

  /// The merge request the caller already had, if any, so the screen can paint
  /// immediately. The activity feed only knows the iid and leaves this null.
  final MergeRequest? mergeRequest;

  MergeRequestArgs copyWith({MergeRequest? mergeRequest}) => MergeRequestArgs(
        projectId: projectId,
        mergeRequestIid: mergeRequestIid,
        mergeRequest: mergeRequest ?? this.mergeRequest,
      );

  @override
  String toString() =>
      'MergeRequestArgs(projectId: $projectId, mergeRequestIid: $mergeRequestIid)';
}

/// What the milestone routes are about.
///
/// Note this is an `id`, not an `iid` like issues and merge requests use.
/// GitLab's milestone endpoints take the global milestone id.
class MilestoneArgs {
  const MilestoneArgs({
    required this.projectId,
    required this.milestoneId,
    this.milestone,
  });

  final int projectId;

  final int milestoneId;

  /// The milestone the caller already had, if any, so the screen can paint
  /// immediately. The activity feed only knows the id and leaves this null.
  final ProjectMilestone? milestone;

  MilestoneArgs copyWith({ProjectMilestone? milestone}) => MilestoneArgs(
        projectId: projectId,
        milestoneId: milestoneId,
        milestone: milestone ?? this.milestone,
      );

  @override
  String toString() =>
      'MilestoneArgs(projectId: $projectId, milestoneId: $milestoneId)';
}

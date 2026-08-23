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
  });

  final int projectId;

  final int issueIid;

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
  });

  final int projectId;

  final int mergeRequestIid;

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
  });

  final int projectId;

  final int milestoneId;

  @override
  String toString() =>
      'MilestoneArgs(projectId: $projectId, milestoneId: $milestoneId)';
}

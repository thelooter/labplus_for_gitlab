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

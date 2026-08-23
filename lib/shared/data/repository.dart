import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:labplus_for_gitlab/models/models.dart';
import 'package:labplus_for_gitlab/shared/data/domain_events.dart';

class Repository {
  Repository({required this.events});

  var project = Project().obs;
  var projectId = 0;
  var commit = Commit().obs;
  var issue = Issue().obs;
  var note = Note().obs;
  var mergeRequest = MergeRequest().obs;
  var detailedMergeRequest = DetailedMergeRequest().obs;
  var milestone = ProjectMilestone().obs;
  var snippet = ProjectSnippet().obs;
  var snippetContent = ''.obs;
  var issueLabels = <ProjectLabel>[].obs;
  var label = ProjectLabel().obs;
  var latestPipeline = Pipeline().obs;

  var group = Group().obs;
  var ref = "".obs;
  var filePath = "".obs;
  var account = AppAccount().obs;

  var loadProjectRequired = false.obs;

  /// Typed replacement for the eight `0.obs` counters that used to live here.
  ///
  /// Two of those counters were not doing anything at all: `labelUpdate` was
  /// never read or written, and `mergeRequestNotesUpdate` had a listener in
  /// MergeRequestNotesController but no emitter anywhere — merge request notes
  /// are read-only, there is no API method to create one. Both are gone rather
  /// than ported. See DomainEvents.
  final DomainEvents events;

  var membersFor = MembersFor.project;
}

enum MembersFor { project, group }

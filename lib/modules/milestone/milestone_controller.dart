import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:labplus_for_gitlab/api/api.dart';
import 'package:labplus_for_gitlab/models/models.dart';
import 'package:labplus_for_gitlab/modules/milestone/milestone_screen.dart';
import 'package:labplus_for_gitlab/routes/app_pages.dart';
import 'package:labplus_for_gitlab/routes/route_args.dart';
import 'package:labplus_for_gitlab/shared/shared.dart';
import 'package:get/get.dart';

class MilestoneController extends GetxController
    with HttpController, PagingController {
  final ApiRepository apiRepository;
  final Repository repository;

  /// Which milestone this screen is about. Was Repository.milestoneId.
  final MilestoneArgs args;

  MilestoneController({
    required this.apiRepository,
    required this.repository,
    required this.args,
  });

  var issues = <Issue>[].obs;
  var mr = <MergeRequest>[].obs;
  var completePerc = 0.obs;
  var completePercProgress = 0.0.obs;

  late StreamSubscription _milestoneUpdateSubscription;

  var _dontReload = false;

  @override
  void onReady() async {
    _milestoneUpdateSubscription = repository.events.on<MilestonesChanged>().listen((p0) {
      if (_dontReload) return;
      getMilestone();
    });

    onRefresh();

    super.onReady();
  }

  @override
  void onClose() {
    _milestoneUpdateSubscription.cancel();
    super.onClose();
  }

  Future<void> getMilestone() async {
    await runWithErrorHandlingWithoutState(() async {
      repository.milestone.value = (await apiRepository.getProjectMilestone(
              args.projectId,
              args.milestoneId)).unwrap();
    });
  }

  Future<void> getIssues() async {
    await runWithErrorHandlingWithoutState(() async {
      var res = (await apiRepository.getMilestoneIssues(
              args.projectId,
              args.milestoneId)).unwrap();
      issues.value = initPagingList(res);
    });
  }

  Future<void> getMR() async {
    await runWithErrorHandlingWithoutState(() async {
      var res = (await apiRepository.getMilestoneMR(
              args.projectId,
              args.milestoneId)).unwrap();
      mr.value = initPagingList(res);
    });
  }

  onPopupSelected(MilestoneScreenPopupActions value, context) async {
    switch (value) {
      case MilestoneScreenPopupActions.edit:
        Get.toNamed(Routes.editMilestone, arguments: args);
        break;
      case MilestoneScreenPopupActions.close:
        EasyLoading.show();
        await runWithErrorHandlingWithoutState(() async {
          (await apiRepository.updateProjectMilestone(
              args.projectId,
              args.milestoneId,
              AddUpdateMilestoneRequest(stateEvent: MilestoneStateEvent.close))).unwrap();
          repository.events.emit(const MilestonesChanged());
        }).then((value) => handleHttpActionState(value));
        EasyLoading.dismiss();
        break;
      case MilestoneScreenPopupActions.reopen:
        EasyLoading.show();
        await runWithErrorHandlingWithoutState(() async {
          (await apiRepository.updateProjectMilestone(
              args.projectId,
              args.milestoneId,
              AddUpdateMilestoneRequest(
                  stateEvent: MilestoneStateEvent.active))).unwrap();
          repository.events.emit(const MilestonesChanged());
        }).then((value) => handleHttpActionState(value));
        EasyLoading.dismiss();
        break;
      case MilestoneScreenPopupActions.delete:
        showDialog(
          context: context,
          builder: (context) => QuestionMessagePresetsDialog(
            title: 'Delete milestone'.tr,
            text: 'Are you sure?'.tr,
            action: () async {
              _dontReload = true;
              EasyLoading.show();
              await runWithErrorHandlingWithoutState(() async {
                (await apiRepository.deleteProjectMilestone(
                    args.projectId,
                    args.milestoneId)).unwrap();
                repository.events.emit(const MilestonesChanged());
                Get.back();
              }).then((value) => handleHttpActionState(value));
              EasyLoading.dismiss();
            },
          ),
        );
        break;
    }
  }

  Future<void> onRefresh() async {
    await getMilestone();
    await getIssues();
    await getMR();

    completePerc.value = calcCompletionStatus();
    completePercProgress.value =
        convertRange(0, 100, 0.0, 1, completePerc.value.toDouble());
  }

  int calcCompletionStatus() {
    var it = 0, ic = 0;

    for (var issue in issues) {
      it++;
      if (issue.state == IssueState.closed) {
        ic++;
      }
    }

    if (it == 0) {
      return 0;
    }

    var perc = (100 / it) * ic;

    if (perc > 100) {
      return 100;
    }

    return perc.round().toInt();
  }

  double convertRange(double originalStart, double originalEnd, double newStart,
      double newEnd, double value) {
    double scale = (newEnd - newStart) / (originalEnd - originalStart);
    return newStart + ((value - originalStart) * scale);
  }

  void navigateToIssue(Issue item) {
    repository.issue.value = item;
    Get.toNamed(
      Routes.issue,
      arguments: IssueArgs(
        projectId: args.projectId,
        issueIid: item.iid ?? 0,
        issue: item,
      ),
    );
  }

  void navigateToMr(MergeRequest item) {
    repository.mergeRequest.value = item;
    Get.toNamed(
      Routes.mergeRequest,
      arguments: MergeRequestArgs(
        projectId: args.projectId,
        mergeRequestIid: item.iid ?? 0,
        mergeRequest: item,
      ),
    );
  }
}

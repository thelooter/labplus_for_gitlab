import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:labplus_for_gitlab/api/api.dart';
import 'package:labplus_for_gitlab/models/models.dart';
import 'package:labplus_for_gitlab/shared/shared.dart';
import 'package:labplus_for_gitlab/routes/route_args.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditMilestoneController extends GetxController
    with HttpController, PagingController {
  final ApiRepository apiRepository;
  final Repository repository;

  /// Which milestone this screen is about. Was Repository.milestoneId.
  final MilestoneArgs args;

  EditMilestoneController({
    required this.apiRepository,
    required this.repository,
    required this.args,
  });

  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final dueDateController = TextEditingController();
  final descriptionController = TextEditingController();

  var dueDateInitVal = ''.obs;
  var dueDateFinal = '';

  @override
  void onInit() {
    titleController.text = repository.milestone.value.title ?? '';
    descriptionController.text = repository.milestone.value.description ?? '';
    dueDateController.text = DateFormat('yyyy-MM-dd')
        .format(repository.milestone.value.dueDate ?? DateTime.now());
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    titleController.dispose();
    dueDateController.dispose();
    descriptionController.dispose();
  }

  Future<void> updateProjectMilestone() async {
    EasyLoading.show();
    await runWithErrorHandlingWithoutState(() async {
      (await apiRepository.updateProjectMilestone(
          args.projectId,
          args.milestoneId,
          AddUpdateMilestoneRequest(
            title: titleController.text,
            description: descriptionController.text,
            dueDate: dueDateController.text,
          ))).unwrap();
      repository.events.emit(const MilestonesChanged());
      Get.back();
    }).then((value) => handleHttpActionState(value));
    EasyLoading.dismiss();
  }
}

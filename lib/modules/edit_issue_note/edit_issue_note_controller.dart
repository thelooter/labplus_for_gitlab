import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:labplus_for_gitlab/api/api.dart';
import 'package:labplus_for_gitlab/models/models.dart';
import 'package:labplus_for_gitlab/routes/route_args.dart';
import 'package:labplus_for_gitlab/shared/shared.dart';
import 'package:get/get.dart';

class EditIssueNoteController extends GetxController with HttpController {
  final ApiRepository apiRepository;
  final Repository repository;

  /// Which issue this screen is about. Was Repository.issueIid.
  final IssueArgs args;

  EditIssueNoteController({
    required this.apiRepository,
    required this.repository,
    required this.args,
  });

  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  final bodyController = TextEditingController();

  @override
  void onInit() {
    bodyController.text = repository.note.value.body ?? '';
    super.onInit();
  }

  @override
  void onClose() {
    bodyController.dispose();
    super.onClose();
  }

  Future<void> save() async {
    EasyLoading.show();
    await runWithErrorHandlingWithoutState(() async {
      (await apiRepository.updateProjectIssueNote(
        args.projectId,
        args.issueIid,
        repository.note.value.id!,
        UpdateIssueNoteRequest(body: bodyController.text),
      )).unwrap();
      repository.note.value = Note(body: bodyController.text);
      repository.events.emit(const IssueNotesChanged());
      Get.back();
    }).then((value) => handleHttpActionState(value));
    EasyLoading.dismiss();
  }

  Future<void> delete(context) async {
    showDialog(
      context: context,
      builder: (context) => QuestionMessagePresetsDialog(
        title: 'Delete note'.tr,
        text: 'Are you sure?'.tr,
        action: () async {
          EasyLoading.show();
          await runWithErrorHandlingWithoutState(() async {
            (await apiRepository.deleteProjectIssueNote(
              args.projectId,
              args.issueIid,
              repository.note.value.id!,
            )).unwrap();
            repository.events.emit(const IssueNotesChanged());
            Get.back();
          }).then((value) => handleHttpActionState(value));
          EasyLoading.dismiss();
        },
      ),
    );
  }
}

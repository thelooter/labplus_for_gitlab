import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:labplus_for_gitlab/api/api.dart';
import 'package:labplus_for_gitlab/models/models.dart';
import 'package:labplus_for_gitlab/routes/app_pages.dart';
import 'package:labplus_for_gitlab/routes/route_args.dart';
import 'package:labplus_for_gitlab/shared/shared.dart';
import 'package:get/get.dart';

class IssueNotesController extends GetxController
    with HttpController, PagingController {
  final ApiRepository apiRepository;
  final Repository repository;

  /// Which issue this screen is about. Was Repository.issueIid.
  final IssueArgs args;

  IssueNotesController({
    required this.apiRepository,
    required this.repository,
    required this.args,
  });

  final bodyController = TextEditingController();

  late ScrollController scrollController = ScrollController()
    ..addListener(_scrollListener);

  late PagingResponse<Note> _notesRes;

  var notes = <Note>[].obs;

  var _page = 0;

  late StreamSubscription _update;

  @override
  void onReady() async {
    super.onReady();
    _update = repository.events.on<IssueNotesChanged>().listen((p0) {
      listNotes();
    });
    listNotes();
  }

  @override
  void onClose() {
    bodyController.dispose();
    scrollController.dispose();
    _update.cancel();
    super.onClose();
  }

  Future<void> listNotes() async {
    await runWithErrorHandling(() async {
      _notesRes = (await apiRepository.listProjectIssueNotes(
              args.projectId,
              args.issueIid,
              NotesRequest(sort: Sort.desc))).unwrap();
      var list = initPagingList(_notesRes);
      notes.value = list.reversed.toList();
    });
  }

  Future<void> listNotesMore(int page) async {
    _page = page;
    await runWithErrorHandlingWithoutState(() async {
      _notesRes = (await apiRepository.listProjectIssueNotes(
              args.projectId,
              args.issueIid,
              NotesRequest(page: page, sort: Sort.desc))).unwrap();
      if (page == 1) {
        notes.value = initPagingList(_notesRes);
      } else {
        notes.addAll(initPagingList(_notesRes));
      }
    });
  }

  Future<void> onNavToEdit(Note item) async {
    repository.note.value = item;
    Get.toNamed(Routes.editIssueNote, arguments: args);
  }

  Future<void> onCreateNew() async {
    if (bodyController.text.isEmpty) {
      CommonWidget.toast('Comment field should not be empty');
      return;
    }

    EasyLoading.show();
    await runWithErrorHandlingWithoutState(() async {
      (await apiRepository.addProjectIssueNote(
        args.projectId,
        args.issueIid,
        NewIssueNoteRequest(body: bodyController.text),
      )).unwrap();
      repository.note.value = Note(body: bodyController.text);
      repository.events.emit(const IssueNotesChanged());
      repository.events.emit(const IssuesChanged());
    }).then((value) => handleHttpActionWithoutState(value));
    EasyLoading.dismiss();
    bodyController.clear();
  }

  void _scrollListener() {
    scrollListener(
        scrollController, _notesRes, (value) => listNotesMore(value), _page);
  }
}

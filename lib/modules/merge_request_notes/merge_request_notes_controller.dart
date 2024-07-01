import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:labplus_for_gitlab/api/api_repository.dart';
import 'package:labplus_for_gitlab/models/models.dart';
import 'package:labplus_for_gitlab/shared/data/repository.dart';
import 'package:labplus_for_gitlab/shared/http_controller.dart';
import 'package:labplus_for_gitlab/shared/paging_controller.dart';

class MergeRequestNotesController extends GetxController
    with HttpController, PagingController {
  final ApiRepository apiRepository;
  final Repository repository;

  MergeRequestNotesController({
    required this.apiRepository,
    required this.repository,
  });

  late ScrollController scrollController = ScrollController()
    ..addListener(_scrollListener);
  late PagingResponse<Note> _notesResponse;
  var notes = <Note>[].obs;
  var _page = 0;
  late StreamSubscription _update;

  @override
  void onReady() {
    super.onReady();
    _update = repository.mergeRequestNotesUpdate.listen((p0) {
      listNotes();
    });
    listNotes();
  }

  @override
  void onClose() {
    scrollController.dispose();
    _update.cancel();
    super.onClose();
  }

  Future<void> listNotes() async {
    await runWithErrorHandling(
      () async {
        _notesResponse = await apiRepository.listProjectMergeRequestNotes(
                repository.project.value.id ?? repository.projectId,
                repository.mergeRequest.value.iid ?? repository.mergeRequestIid,
                NotesRequest(sort: Sort.desc)) ??
            PagingResponse<Note>();

        var list = initPagingList(_notesResponse);
        var templist = <Note>[];
        for (var element in list) {
          if(!element.body!.startsWith("changed this line")) {
          templist.add(element);
          }
        }
        notes.value = templist.reversed.toList();
      },
    );
  }

  Future<void> listNotesMore(int page) async {
    _page = page;
    await runWithErrorHandlingWithoutState(() async {
      _notesResponse = await apiRepository.listProjectMergeRequestNotes(
              repository.project.value.id ?? repository.projectId,
              repository.mergeRequest.value.iid ?? repository.mergeRequestIid,
              NotesRequest(page: page, sort: Sort.desc)) ??
          PagingResponse<Note>();
      if (page == 1) {
        notes.value = initPagingList(_notesResponse);
      } else {
        notes.addAll(initPagingList(_notesResponse));
      }
    });
  }

  void _scrollListener() {
    scrollListener(scrollController, _notesResponse,
        (value) => listNotesMore(value), _page);
  }
}

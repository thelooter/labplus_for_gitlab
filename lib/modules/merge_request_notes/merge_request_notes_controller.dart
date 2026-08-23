import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:labplus_for_gitlab/api/api_repository.dart';
import 'package:labplus_for_gitlab/models/models.dart';
import 'package:labplus_for_gitlab/shared/data/repository.dart';
import 'package:labplus_for_gitlab/shared/http_controller.dart';
import 'package:labplus_for_gitlab/shared/paging_controller.dart';
import 'package:labplus_for_gitlab/routes/route_args.dart';

class MergeRequestNotesController extends GetxController
    with HttpController, PagingController {
  final ApiRepository apiRepository;
  final Repository repository;

  /// Which merge request this screen is about. Was Repository.mergeRequestIid.
  final MergeRequestArgs args;

  MergeRequestNotesController({
    required this.apiRepository,
    required this.repository,
    required this.args,
  });

  late ScrollController scrollController = ScrollController()
    ..addListener(_scrollListener);
  late PagingResponse<Note> _notesResponse;
  var notes = <Note>[].obs;
  var _page = 0;

  // There was a subscription here to a `mergeRequestNotesUpdate` counter that
  // nothing ever incremented — merge request notes are read-only, there is no
  // API method to create, edit or delete one. It was dead wiring copied from
  // the issue notes module. Removed along with the counter.
  @override
  void onReady() {
    super.onReady();
    listNotes();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> listNotes() async {
    await runWithErrorHandling(
      () async {
        _notesResponse = (await apiRepository.listProjectMergeRequestNotes(
                args.projectId,
                args.mergeRequestIid,
                NotesRequest(sort: Sort.desc))).unwrap();

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
      _notesResponse = (await apiRepository.listProjectMergeRequestNotes(
              args.projectId,
              args.mergeRequestIid,
              NotesRequest(page: page, sort: Sort.desc))).unwrap();
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

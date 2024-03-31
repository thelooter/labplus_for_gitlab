import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:gitplus_for_gitlab/api/api_repository.dart';
import 'package:gitplus_for_gitlab/models/models.dart';
import 'package:gitplus_for_gitlab/shared/data/repository.dart';
import 'package:gitplus_for_gitlab/shared/http_controller.dart';
import 'package:gitplus_for_gitlab/shared/paging_controller.dart';

class PipelinesController extends GetxController
    with HttpController, PagingController {
  final ApiRepository apiRepository;
  final Repository repository;

  PipelinesController({required this.apiRepository, required this.repository});

  late PagingResponse<Pipeline> _pipelinesRes;

  var _page = 0;

  var pipelines = <Pipeline>[].obs;

  late ScrollController scrollController = ScrollController()
    ..addListener(_scrollListener);

  @override
  void onReady() {
    super.onReady();

    list();
  }

  Future<void> list() async {
    _page = 0;

    await runWithErrorHandling(() async {
      _pipelinesRes =
          await apiRepository.listPipelines(
              repository.project.value.id!, ListPipelinesRequest()) ??
              PagingResponse<Pipeline>();
      pipelines.value = initPagingList(_pipelinesRes);
    }).then((value) {
      if (value == 401) {
        state.value = HttpState.tokenExpired;
        return;
      }
      if (value > 0) return;
      if (pipelines.isEmpty) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          state.value = HttpState.empty;
        });
      }
    });
  }

  Future<void> listMore(int page) async {
    String? scope;

    _page = page;
    await runWithErrorHandlingWithoutState(() async {
      _pipelinesRes = await apiRepository.listPipelines(
          repository.project.value.id!,
          ListPipelinesRequest(page: page, scope: scope)) ??
          PagingResponse<Pipeline>();
      if (page == 1) {
        pipelines.value = initPagingList(_pipelinesRes);
      } else {
        pipelines.addAll(initPagingList(_pipelinesRes));
      }
    });
  }

  Future<void> _scrollListener() async {
    scrollListener(
        scrollController, _pipelinesRes, (value) => listMore(value), _page);
  }
}

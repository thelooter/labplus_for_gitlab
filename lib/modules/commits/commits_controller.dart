import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:labplus_for_gitlab/api/api.dart';
import 'package:labplus_for_gitlab/models/models.dart';
import 'package:labplus_for_gitlab/routes/app_pages.dart';
import 'package:labplus_for_gitlab/shared/shared.dart';
import 'package:get/get.dart';

class CommitsController extends GetxController
    with HttpController, PagingController {
  final ApiRepository apiRepository;
  final Repository repository;

  CommitsController({
    required this.apiRepository,
    required this.repository,
  });

  late ScrollController scrollControllerCommits = ScrollController()
    ..addListener(_scrollListenerCommits);

  var commits = <Commit>[].obs;

  late PagingResponse<Commit> _simpleCommitsRes;
  late Commit _commitsRes;
  var _pageCommits = 0;

  @override
  void onReady() async {
    super.onReady();
    listCommits();
  }

  @override
  void onClose() {
    scrollControllerCommits.dispose();
    super.onClose();
  }

  Future<void> listCommits() async {
    await runWithErrorHandling(() async {
      _simpleCommitsRes = await apiRepository.listCommits(
              repository.project.value.id ?? repository.projectId,
              CommitsReqest()) ??
          PagingResponse<Commit>();
      var simpleCommits = initPagingList(_simpleCommitsRes);

      for (var commit in simpleCommits) {
        _commitsRes = await apiRepository.getCommit(
            repository.project.value.id ?? repository.projectId,
            commit.id!,
            CommitReqest()) ??
            Commit();

        commits.add(_commitsRes);
      }
    }).then((value) {
      if (value == 401) {
        state.value = HttpState.tokenExpired;
        return;
      }
      if (value > 0) return;
      if (commits.isEmpty) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          state.value = HttpState.empty;
        });
      }
    });
  }

  Future<void> listCommitsMore(int page) async {
    _pageCommits = page;
    await runWithErrorHandlingWithoutState(() async {
      _simpleCommitsRes = await apiRepository.listCommits(
              repository.project.value.id ?? repository.projectId,
              CommitsReqest(page: page)) ??
          PagingResponse<Commit>();
      if (page == 1) {
        commits.value = initPagingList(_simpleCommitsRes);
      } else {
        commits.addAll(initPagingList(_simpleCommitsRes));
      }
    });
  }

  Future<void> _scrollListenerCommits() async {
    scrollListener(scrollControllerCommits, _simpleCommitsRes,
        (value) => listCommitsMore(value), _pageCommits);
  }

  void onCommitSelected(Commit item) {
    repository.commit.value = item;
    Get.toNamed(Routes.commit);
  }
}

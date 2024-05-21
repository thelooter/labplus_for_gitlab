import 'package:flutter/material.dart';
import 'package:labplus_for_gitlab/models/models.dart';
import 'package:labplus_for_gitlab/shared/shared.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';

import 'commits.dart';

class CommitsScreen extends GetView<CommitsController> {
  const CommitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildWidget());
  }

  Widget _buildWidget() {
    // ignore: unused_local_variable
    var l = controller.commits.length;
    return Scaffold(
      appBar: AppBar(
        title: Text("Commits".tr),
      ),
      body: _CommitsList(controller: controller),
    );
  }
}

class _CommitsList extends StatelessWidget {
  final CommitsController controller;

  const _CommitsList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.listCommits(),
      child: HttpFutureBuilder(
        state: controller.state.value,
        child: Scrollbar(
          controller: controller.scrollControllerCommits,
          child: GroupedListView<Commit, DateTime>(
              // ignore: invalid_use_of_protected_member
              elements: controller.commits.value,
              controller: controller.scrollControllerCommits,
              physics: const AlwaysScrollableScrollPhysics(),
              order: GroupedListOrder.DESC,
              groupBy: (Commit element) => DateTime(
                    element.createdAt!.year,
                    element.createdAt!.month,
                    element.createdAt!.day,
                  ),
              groupSeparatorBuilder: (DateTime element) =>
                  _CommitsGroupSeparator(date: element),
              itemComparator: (element1, element2) =>
                  element1.createdAt!.compareTo(element2.createdAt!),
              itemBuilder: (context, element) {
                return _CommitsListItem(
                    commit: element, controller: controller);
              }),
        ),
      ),
    );
  }
}

class _CommitsListItem extends StatelessWidget {
  final Commit commit;
  final CommitsController controller;

  const _CommitsListItem({
    required this.commit,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    var statusString = getStatusString();
    var statusIcon = getStatusIcon();

    return Column(
      children: [
        ListTile(
          // contentPadding: CommonConstants.contentPaddingLitTileLarge,
          title: Text(
            commit.title!,
            style:
                const TextStyle(fontWeight: CommonConstants.fontWeightListTile),
          ),
          trailing: const Icon(Icons.keyboard_arrow_right),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              // Text(item.shortId!),
              // const SizedBox(height: 5),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: "${commit.authorName!} ",
                        style: const TextStyle(
                            fontWeight: CommonConstants.fontWeightListTile)),
                    TextSpan(
                        text: "authored ${timeago.format(commit.createdAt!)}",
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              Row(
                children: [
                  if (statusIcon != null) statusIcon,
                  const SizedBox(
                    width: 10.0,
                  ),
                  if (statusIcon != null) Text(statusString)
                ],
              )
            ],
          ),
          onTap: () {
            controller.onCommitSelected(commit);
          },
        ),
        const Divider(),
      ],
    );
  }

  String getStatusString() {
    return switch (commit.status) {
      "success" => "Success",
      "failed" => "Failed",
      "created" => "Created",
      "waiting_for_resource" => "Waiting for Resource",
      "preparing" => "Preparing",
      "pending" => "Pending",
      "scheduled" => "Scheduled",
      "skipped" => "Skipped",
      "canceled" => "Canceled",
      "running" => "Running",
      "manual" => "Manual",
      null => "",
      String() => throw UnimplementedError(),
    };
  }

  getStatusIcon() {
    if (commit.lastPipeline != null) {
      switch (commit.status) {
        case "success":
          return const Icon(Icons.check, color: Colors.green);
        case "failed":
          return const Icon(Icons.close, color: Colors.red);
        case "created":
          return const Icon(Icons.schedule_outlined, color: Colors.yellow);
        case "waiting_for_resource":
          return const Icon(Icons.schedule_outlined, color: Colors.yellow);
        case "preparing":
          return const Icon(Icons.schedule_outlined, color: Colors.yellow);
        case "pending":
          return const Icon(Icons.schedule_outlined, color: Colors.yellow);
        case "scheduled":
          return const Icon(Icons.schedule_outlined, color: Colors.yellow);
        case "skipped":
          return const Icon(Icons.remove, color: Colors.grey);
        case "canceled":
          return const Icon(Icons.remove, color: Colors.grey);
        case "running":
          return const Icon(Icons.cached, color: Colors.blue);
        case "manual":
          return const Icon(Icons.cached, color: Colors.blue);
        case null:
          return const Icon(Icons.question_mark);
        case String():
          return const Icon(Icons.question_mark);
      }
    }
  }
}

class _CommitsGroupSeparator extends StatelessWidget {
  final DateTime date;

  const _CommitsGroupSeparator({required this.date});

  @override
  Widget build(BuildContext context) {
    final String formatted = DateFormat('dd MMMM, yyyy').format(date);

    return Column(
      children: [
        ListTile(
            title: Text(
          formatted.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        )),
        const Divider(),
      ],
    );
  }
}

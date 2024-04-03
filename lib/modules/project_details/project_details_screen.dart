import 'package:file_icon/file_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:get/get.dart';
import 'package:labplus_for_gitlab/models/models.dart';
import 'package:labplus_for_gitlab/modules/project_details/project_menu_item.dart';
import 'package:labplus_for_gitlab/modules/tree_view/tree_view.dart';
import 'package:labplus_for_gitlab/routes/routes.dart';
import 'package:labplus_for_gitlab/shared/shared.dart';

import 'project_details.dart';

enum ProjectDetailsScreenPopup { edit, share, webUrl, delete }

class ProjectDetailsScreen extends GetView<ProjectDetailsController> {
  const ProjectDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildWidget(context));
  }

  Widget _buildWidget(context) {
    var project = controller.repository.project.value;
    if (project.id == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const LoadingWidget(),
      );
    }

    if (controller.repository.latestPipeline.value.status == "") {
      return Scaffold(
        appBar: AppBar(),
        body: const LoadingWidget(),
      );
    }

    const spacing = 8.0;

    Widget visibility = Container();
    switch (project.visibility) {
      case GitLabVisibility.public:
        visibility = _iconLabel(Icons.public, "Public".tr);
        break;
      case GitLabVisibility.internal:
        visibility = _iconLabel(Icons.lock_outline, "Internal".tr);
        break;
      case GitLabVisibility.private:
        visibility = _iconLabel(Icons.lock_outline, "Private".tr);
        break;
    }

    Widget avatar;
    if (project.avatarUrl != null && project.avatarUrl!.isNotEmpty) {
      avatar = ListAvatar(avatarUrl: project.avatarUrl!);
    } else {
      avatar = CircleAvatar(
          minRadius: 20,
      maxRadius: 40,
          child: Text(project.name!.toUpperCase().substring(0, 2),textScaler: const TextScaler.linear(1.8),),);
    }

    var pipelineStatusExists = controller.repository.latestPipeline.value
        .status != "";

    IconData statusIcon = Octicons.question;
    String statusString = "";
    if (controller.repository.latestPipeline.value.status != "") {
      statusIcon = switch (controller.repository.latestPipeline.value.status) {
        "success" => Octicons.check,
        "failed" => Octicons.x,
        "created" => Octicons.clock,
        "waiting_for_resource" => Octicons.clock,
        "preparing" => Octicons.clock,
        "pending" => Octicons.clock,
        "scheduled" => Octicons.clock,
        "skipped" => Octicons.dash,
        "canceled" => Octicons.dash,
        "running" => Octicons.dot_fill,
        "manual" => Octicons.dot_fill,
        String() => Octicons.question,
        null => Octicons.question,
      };

      statusString = switch (controller.repository.latestPipeline.value.status) {
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
        String() => "",
        null => "",
      };
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(project.name ?? ""),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) =>
            <PopupMenuEntry<ProjectDetailsScreenPopup>>[
              if (controller.canModifyOrDelete.value)
                PopupMenuItem(
                    value: ProjectDetailsScreenPopup.edit,
                    child: Text('Edit'.tr)),
              PopupMenuItem(
                  value: ProjectDetailsScreenPopup.share,
                  child: Text('Share'.tr)),
              PopupMenuItem(
                  value: ProjectDetailsScreenPopup.webUrl,
                  child: Text('Open in web browser'.tr)),
              if (controller.canModifyOrDelete.value) const PopupMenuDivider(),
              if (controller.canModifyOrDelete.value)
                PopupMenuItem(
                    value: ProjectDetailsScreenPopup.delete,
                    child: Text(
                      'Delete'.tr,
                      style: const TextStyle(color: Colors.red),
                    )),
            ],
            onSelected: (ProjectDetailsScreenPopup value) =>
                controller.onPopupSelected(value, context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.onRefreshAll(),
        child: ListView(
          shrinkWrap: true,
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(alignment: Alignment.center,child:avatar),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(project.nameWithNamespace!,
                                style: const TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        visibility,
                        const SizedBox(width: 10),
                        // stars
                        _iconLabel(Octicons.star,
                            "${project.starCount} stars"),
                        // forks
                        const SizedBox(width: 10),
                        _iconLabel(Octicons.git_branch,
                            "${project.forksCount} forks"),
                        if(pipelineStatusExists) const SizedBox(width: 10),
                        if(pipelineStatusExists) _iconLabel(statusIcon, statusString)
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            ///

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(children: [
                  IntrinsicHeight(
                    child: Flex(direction: Axis.horizontal, children: [
                      Expanded(
                          child: ProjectMenuItemWidget(
                            icon: Icons.event,
                            text: 'Activity',
                            onPressed: () {
                              Get.toNamed(Routes.projectActivity);
                            },
                          )),
                      const SizedBox(width: spacing),
                      Expanded(
                          child: ProjectMenuItemWidget(
                            icon: Octicons.issue_opened,
                            text: 'Issues',
                            onPressed: () {
                              Get.toNamed(Routes.issues);
                            },
                          )),
                      const SizedBox(width: spacing),
                      Expanded(
                          child: ProjectMenuItemWidget(
                            icon: Octicons.milestone,
                            text: 'Milestones',
                            onPressed: () {
                              Get.toNamed(Routes.milestones);
                            },
                          )),
                    ]),
                  ),
                  const SizedBox(height: spacing),
                  IntrinsicHeight(
                    child: Flex(direction: Axis.horizontal, children: [
                      Expanded(
                          child: ProjectMenuItemWidget(
                            icon: Octicons.git_merge,
                            text: 'MR',
                            onPressed: () {
                              Get.toNamed(Routes.mergeRequests);
                            },
                          )),
                      const SizedBox(width: spacing),
                      Expanded(
                          child: ProjectMenuItemWidget(
                            icon: Icons.label_outline,
                            text: 'Labels',
                            onPressed: () {
                              Get.toNamed(Routes.labels);
                            },
                          )),
                      const SizedBox(width: spacing),
                      Expanded(
                          child: ProjectMenuItemWidget(
                            icon: Icons.text_snippet_outlined,
                            text: 'Snippets',
                            onPressed: () {
                              Get.toNamed(Routes.projectSnippets);
                            },
                          )),
                    ]),
                  ),
                  const SizedBox(height: spacing),
                  IntrinsicHeight(
                    child: Flex(direction: Axis.horizontal, children: [
                      Expanded(
                          child: ProjectMenuItemWidget(
                            icon: Icons.star_border_outlined,
                            text: 'Starrers',
                            onPressed: () {
                              Get.toNamed(Routes.starrers);
                            },
                          )),
                      const SizedBox(width: spacing),
                      Expanded(
                          child: ProjectMenuItemWidget(
                            icon: Icons.people_outline_rounded,
                            text: 'Members',
                            onPressed: () {
                              controller.repository.membersFor =
                                  MembersFor.project;
                              Get.toNamed(Routes.projectMembers);
                            },
                          )),
                      const SizedBox(width: spacing),
                      Expanded(
                          child: ProjectMenuItemWidget(
                            icon: Icons.check_box_outlined,
                            text: 'Pipelines',
                            onPressed: () {
                              Get.toNamed(Routes.pipelines);
                            },
                          )),
                    ]),
                  ),
                  const SizedBox(height: spacing),
                  Flex(direction: Axis.horizontal, children: [
                    Expanded(
                        child: ProjectMenuItemWidget(
                          icon: Icons.code,
                          text: 'Browse code',
                          onPressed: () {
                            Get.toNamed(Routes.treeViewRoot,
                                arguments: TreeViewArgs(
                                    name: project.name ?? "", path: ""));
                          },
                        )),
                    const SizedBox(width: spacing),
                    Expanded(
                        child: ProjectMenuItemWidget(
                          icon: Octicons.git_commit,
                          text: 'Commits',
                          onPressed: () {
                            Get.toNamed(Routes.commits);
                          },
                        )),
                  ]),
                ]),
              ),
            ),

            if (controller.readmeConent.isNotEmpty)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            FileIcon(controller.readmeFilename.value, size: 30),
                            const SizedBox(width: 15),
                            Flexible(
                              child: Text(
                                controller.readmeFilename.value,
                                style: const TextStyle(
                                    fontFamily: 'SourceCodePro'),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (controller.readmeConent.isNotEmpty)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: AppMarkdown(content: controller.readmeConent.string),
                ),
              ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _iconLabel(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon),
        const SizedBox(width: 5),
        Text(text),
      ],
    );
  }
}

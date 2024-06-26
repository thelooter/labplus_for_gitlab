import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labplus_for_gitlab/models/models.dart';
import 'package:labplus_for_gitlab/modules/home/home.dart';
import 'package:labplus_for_gitlab/shared/shared.dart';
import 'package:timeago/timeago.dart' as timeago;

class MergeRequestsTab extends GetView<HomeController> {
  const MergeRequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildList(controller, controller.mergeRequests));
  }
}

Widget _buildList(HomeController controller, List<MergeRequest> items) {
  return RefreshIndicator(
    onRefresh: () => controller.listMergeRequests(),
    child: HttpFutureBuilder(
      state: controller.mrState.value,
      child: Scrollbar(
        controller: controller.mrScrollController,
        child: ListView.builder(
            controller: controller.mrScrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              var item = items[index];
              return _buildListItem(controller, item, context);
            }),
      ),
    ),
  );
}

Widget _buildListItem(
    HomeController controller, MergeRequest item, BuildContext context) {
  return Column(
    children: [
      ListTile(
        contentPadding: CommonConstants.contentPaddingLitTileLarge,
        leading: ListAvatar(avatarUrl: item.author!.avatarUrl!),
        title: Text(
          item.title!,
          style:
              const TextStyle(fontWeight: CommonConstants.fontWeightListTile),
        ),
        trailing: const Icon(Icons.keyboard_arrow_right),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: "${item.author!.name!} ",
                      style: const TextStyle(
                          fontWeight: CommonConstants.fontWeightListTile)),
                  TextSpan(
                      text: "authored ${timeago.format(item.createdAt!)}",
                      style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 5),
            _stateWidget(item),
          ],
        ),
        onTap: () {
          controller.onNavToMergeRequestDetails(item);
        },
      ),
      const Divider(),
    ],
  );
}

Widget _stateWidget(MergeRequest item) {

  switch(item.state) {
    case MergeRequestState.opened:
      return ColorLabel(color: Colors.green, text: "Open".tr);
    case MergeRequestState.closed:
      return ColorLabel(color: Colors.red, text: "Closed".tr);
    case MergeRequestState.locked:
      return ColorLabel(color: Colors.yellow, text: "Locked".tr);
    case MergeRequestState.merged:
      return ColorLabel(color: Colors.purple, text: "Merged".tr);
  }

  return ColorLabel(color: Colors.white, text: "Unknown".tr);
}
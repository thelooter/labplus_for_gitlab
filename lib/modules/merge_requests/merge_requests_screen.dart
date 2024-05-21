import 'package:flutter/material.dart';
import 'package:labplus_for_gitlab/models/models.dart';
import 'package:labplus_for_gitlab/shared/shared.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:get/get.dart';

import 'merge_requests.dart';

class MergeRequestsScreen extends GetView<MergeRequestsController> {
  const MergeRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildWidget(context));
  }

  Widget _buildWidget(context) {
    // ignore: unused_local_variable
    var l = controller.mergeRequests.length;
    return Scaffold(
      appBar: AppBar(
        title: Text("Merge requests".tr),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (c) {
                    String selectedScopeRadio =
                        controller.mergeRequestsFilterScope.value;
                    String selectedStateRadio =
                        controller.mergeRequestsFilterState.value;
                    return AlertDialog(
                      title: Text('Filter'.tr),
                      content: StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Wrap(
                                spacing: 5,
                                runSpacing: -5,
                                children: [
                                  FilterChip(
                                    label: Text('All'.tr),
                                    selected: selectedStateRadio.isEmpty,
                                    onSelected: (value) {
                                      setState(() => selectedStateRadio = '');
                                      controller.onMergeRequestStateChanged('');
                                    },
                                  ),
                                  FilterChip(
                                    label: Text('Open'.tr),
                                    selected: selectedStateRadio ==
                                        MergeRequestState.opened,
                                    onSelected: (value) {
                                      setState(() => selectedStateRadio =
                                          MergeRequestState.opened);
                                      controller.onMergeRequestStateChanged(
                                          MergeRequestState.opened);
                                    },
                                  ),
                                  FilterChip(
                                    label: Text('Closed'.tr),
                                    selected: selectedStateRadio ==
                                        MergeRequestState.closed,
                                    onSelected: (value) {
                                      setState(() => selectedStateRadio =
                                          MergeRequestState.closed);
                                      controller.onMergeRequestStateChanged(
                                          MergeRequestState.closed);
                                    },
                                  ),
                                  FilterChip(
                                    label: Text('Locked'.tr),
                                    selected: selectedStateRadio ==
                                        MergeRequestState.locked,
                                    onSelected: (value) {
                                      setState(() => selectedStateRadio =
                                          MergeRequestState.locked);
                                      controller.onMergeRequestStateChanged(
                                          MergeRequestState.locked);
                                    },
                                  ),
                                  FilterChip(
                                    label: Text('Merged'.tr),
                                    selected: selectedStateRadio ==
                                        MergeRequestState.merged,
                                    onSelected: (value) {
                                      setState(() => selectedStateRadio =
                                          MergeRequestState.merged);
                                      controller.onMergeRequestStateChanged(
                                          MergeRequestState.merged);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text('Scope'.tr),
                              const SizedBox(height: 5),
                              Wrap(
                                spacing: 5,
                                children: [
                                  FilterChip(
                                    label: Text('All'.tr),
                                    selected: selectedScopeRadio ==
                                        MergeRequestScope.all,
                                    onSelected: (value) {
                                      setState(() => selectedScopeRadio =
                                          MergeRequestScope.all);
                                      controller.onMergeRequestScopeChanged(
                                          MergeRequestScope.all);
                                    },
                                  ),
                                  FilterChip(
                                    label: Text('Created'.tr),
                                    selected: selectedScopeRadio ==
                                        MergeRequestScope.createdByMe,
                                    onSelected: (value) {
                                      setState(() => selectedScopeRadio =
                                          MergeRequestScope.createdByMe);
                                      controller.onMergeRequestScopeChanged(
                                          MergeRequestScope.createdByMe);
                                    },
                                  ),
                                  FilterChip(
                                    label: Text('Assigned'.tr),
                                    selected: selectedScopeRadio ==
                                        MergeRequestScope.assignedToMe,
                                    onSelected: (value) {
                                      setState(() => selectedScopeRadio =
                                          MergeRequestScope.assignedToMe);
                                      controller.onMergeRequestScopeChanged(
                                          MergeRequestScope.assignedToMe);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text('Close'.tr)),
                      ],
                    );
                  });
            },
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
          ),
          IconButton(
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: MergeRequestsDataSearch(
                      (s) {
                        controller.onSearchTextChanged(s);
                      },
                      controller,
                    ));
              },
              tooltip: 'Search a merge request'.tr,
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                controller.onNavToNewMR();
              },
              tooltip: 'Create merge request'.tr,
              icon: const Icon(Icons.add)),
        ],
      ),
      body: _MergeRequestList(controller: controller,mergeRequests: controller.foundMergeRequests),
    );
  }
}

class MergeRequestsDataSearch extends SearchDelegate<String> {
  late final Function(String) onSearchTextChanged;
  late final MergeRequestsController controller;

  MergeRequestsDataSearch(this.onSearchTextChanged, this.controller)
      : super(
          searchFieldStyle: const TextStyle(color: Colors.grey),
        );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Get.back();
        },
        icon: searchLeadingIcon());
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearchTextChanged(query);
    return _MergeRequestList(controller: controller,mergeRequests: controller.foundMergeRequests);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    onSearchTextChanged(query);
    return _MergeRequestList(controller: controller,mergeRequests: controller.foundMergeRequests);
  }
}

class _MergeRequestList extends StatelessWidget {

  final MergeRequestsController controller;
  final List<MergeRequest> mergeRequests;

  const _MergeRequestList({
    required this.controller,
    required this.mergeRequests,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => RefreshIndicator(
        onRefresh: () => controller.list(),
        child: HttpFutureBuilder(
          state: controller.state.value,
          child: Scrollbar(

            controller: controller.scrollController,
            child: ListView.builder(
                itemCount: mergeRequests.length,
                controller: controller.scrollController,
                itemBuilder: (context, index) {
                  var item = mergeRequests[index];
                  return _MergeRequestsListItem(
                    controller: controller,
                    mergeRequest: item,
                  );
                }),
          ),
        ),
      ),
    );

  }
}

class _MergeRequestsListItem extends StatelessWidget {
  final MergeRequestsController controller;
  final MergeRequest mergeRequest;

  const _MergeRequestsListItem({
    required this.controller,
    required this.mergeRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: CommonConstants.contentPaddingLitTileLarge,
          leading: ListAvatar(avatarUrl: mergeRequest.author!.avatarUrl!),
          title: Text(
            mergeRequest.title!,
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
                        text: "${mergeRequest.author!.name!} ",
                        style: const TextStyle(
                            fontWeight: CommonConstants.fontWeightListTile)),
                    TextSpan(
                        text:
                            "authored ${timeago.format(mergeRequest.createdAt!)}",
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              _StateWidget(mergeRequest: mergeRequest),
            ],
          ),
          onTap: () {
            controller.onSelected(mergeRequest);
          },
        ),
        const Divider(),
      ],
    );
  }
}

class _StateWidget extends StatelessWidget {
  final MergeRequest mergeRequest;

  const _StateWidget({required this.mergeRequest});

  @override
  Widget build(BuildContext context) {
    switch (mergeRequest.state) {
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
}

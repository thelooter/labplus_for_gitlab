import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labplus_for_gitlab/models/note.dart';
import 'package:labplus_for_gitlab/modules/merge_request_notes/merge_request_notes.dart';
import 'package:labplus_for_gitlab/shared/shared.dart';
import 'package:timelines/timelines.dart';

class MergeRequestNotesScreen extends GetView<MergeRequestNotesController> {
  const MergeRequestNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildWidget(context));
  }

  Widget _buildWidget(BuildContext context) {
    // ignore: unused_local_variable
    var len = controller.notes.length;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Merge Request Notes"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: _MergeRequestNotesTimeline(controller: controller))
        ],
      ),
    );
  }
}

class _MergeRequestNotesTimeline extends StatelessWidget {
  final MergeRequestNotesController controller;

  const _MergeRequestNotesTimeline({required this.controller});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: HttpFutureBuilder(
        state: controller.state.value,
        child: Scrollbar(
          child: Timeline.tileBuilder(
              theme: TimelineTheme.of(context).copyWith(
                nodePosition: 0.03,
                indicatorTheme: TimelineTheme.of(context)
                    .indicatorTheme
                    .copyWith(
                        size: 10.0,
                        position: 0.5,
                        color: Theme.of(context).disabledColor),
                connectorTheme: TimelineTheme.of(context)
                    .connectorTheme
                    .copyWith(
                        thickness: 4.0, color: Theme.of(context).disabledColor),
              ),
              builder: TimelineTileBuilder.fromStyle(
                  contentsAlign: ContentsAlign.basic,
                  indicatorStyle: IndicatorStyle.outlined,
                  contentsBuilder: (context, index) => TimelineItem(
                        note: controller.notes[index],
                        controller: controller,
                      ),
                  itemCount: controller.notes.length)),
        ),
      ),
      onRefresh: () => controller.listNotes(),
    );
  }
}

class TimelineItem extends StatelessWidget {
  final Note note;
  final MergeRequestNotesController controller;

  const TimelineItem({super.key, required this.note, required this.controller});

  @override
  Widget build(BuildContext context) {
    return generateContentItem(note, context);
  }

  Widget generateContentItem(Note note, BuildContext context) {
    var author = note.author!.name ?? note.author!.username;
    if (note.system == true) {
      if (note.body == "requested changes") {
        var author = note.author!.name ?? note.author!.username;
        return Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            child: Row(children: [
              Icon(
                Icons.cancel,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 10),
              Text(
                "$author requested changes",
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              )
            ]));
      }

      if (note.body == "approved this merge request") {
        return Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            child: Row(children: [
              const Icon(
                Icons.cancel,
                color: Colors.green,
              ),
              const SizedBox(width: 10),
              Text(
                "$author approved this merge request",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              )
            ]));
      }
      RegExp commitMatcher = RegExp(r'^(added\s\d+\scommit)');
      if (commitMatcher.hasMatch(note.body!)) {
        return Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            child: Text(
              "$author added commits",
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ));
      }

      if (note.body!.startsWith("changed this line")) {
        return const Text("");
      }

      return Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        child: Text("${author!} ${note.body!}",
            style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
      );
    }

    return Card(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                note.author?.avatarUrl![0].isEmpty == false
                    ? CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: CachedNetworkImage(
                          color: Colors.transparent,
                          imageUrl: note.author!.avatarUrl!,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          httpHeaders: {
                            'PRIVATE-TOKEN':
                                Get.find<SecureStorage>().getToken()
                          },
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 3.0,
                                ),
                              ],
                              image: DecorationImage(image: imageProvider),
                            ),
                          ),
                        ),
                      )
                    : const CircleAvatar(child: Icon(Icons.person)),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(note.author!.name!),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              note.body!,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
            )
          ],
        ),
      ),
    );
  }
}

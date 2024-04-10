import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:labplus_for_gitlab/shared/shared.dart';

import 'package:get/get.dart';
import 'package:timelines/timelines.dart';

import '../../models/note.dart';
import 'issue_notes.dart';

class IssueNotesScreen extends GetView<IssueNotesController> {
  const IssueNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildWidget(context));
  }

  Widget _buildWidget(context) {
    // ignore: unused_local_variable
    var len = controller.notes.length;
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'.tr),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: NotesTimeline(controller: controller)),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Row(children: [
                Expanded(
                  child: TextFormField(
                    autocorrect: false,
                    controller: controller.bodyController,
                    decoration: const InputDecoration(
                      labelText: "Comment",
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      labelStyle: TextStyle(),
                      fillColor: Colors.blue,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          borderSide: BorderSide(color: Colors.purpleAccent)),
                    ),
                  ),
                ),
                // Second child is button
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    controller.onCreateNew();
                  },
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class NotesTimeline extends StatelessWidget {
  final IssueNotesController controller;
  const NotesTimeline({super.key, required this.controller});


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
                    .copyWith(size: 10.0, position: 0.5, color: Colors.grey),
                connectorTheme: TimelineTheme.of(context)
                    .connectorTheme
                    .copyWith(thickness: 4.0, color: Colors.white12),
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
  final IssueNotesController controller;

  const TimelineItem({super.key, required this.note, required this.controller});

  @override
  Widget build(BuildContext context) {
    return generateContentItem(note);
  }

  Widget generateContentItem(Note note) {
    if (note.system == true) {
      if (note.body!.contains("changed health status")) {
        var substringStart = note.body!.indexOf("*");

        var onTrackColor = Colors.white;
        var onTrackString = "";

        if (note.body!.contains("on track")) {
          onTrackColor = Colors.lightGreen;
          onTrackString = "On Track";
        }

        if (note.body!.contains("needs attention")) {
          onTrackColor = Colors.yellow;
          onTrackString = "Needs attention";
        }

        if (note.body!.contains("at risk")) {
          onTrackColor = Colors.red;
          onTrackString = "At risk";
        }

        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 5, top: 10, bottom: 10),
              child: Row(
                children: [
                  Text(note.body!.substring(0, substringStart),
                      style: const TextStyle(color: Colors.white30)),
                  const SizedBox(width: 5),
                  ColorLabel(
                    color: onTrackColor,
                    text: onTrackString,
                    fontSize: 12,
                  )
                ],
              ),
            ),
          ],
        );
      }

      return Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        child: Text(note.body!, style: const TextStyle(color: Colors.white30)),
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
                const Spacer(),
                IconButton(
                  onPressed: () {
                    controller.onNavToEdit(note);
                  },
                  icon: const Icon(
                    Icons.edit,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(note.body!)
          ],
        ),
      ),
    );
  }
}

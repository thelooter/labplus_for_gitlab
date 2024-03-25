import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gitplus_for_gitlab/api/utils.dart';
import 'package:gitplus_for_gitlab/models/models.dart';
import 'package:gitplus_for_gitlab/shared/shared.dart';

import 'package:get/get.dart';

class MemberDetailsScreenArgs {
  final Member member;
  final Future<void> Function() onRemove;

  MemberDetailsScreenArgs({
    required this.member,
    required this.onRemove,
  });
}

class MemberDetailsScreen extends StatelessWidget {
  final MemberDetailsScreenArgs args = Get.arguments;

  MemberDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildWidget(context);
  }

  Widget _buildWidget(context) {
    var m = args.member;

    return Scaffold(
      appBar: AppBar(
        title: Text(m.name ?? ''),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          m.avatarUrl?.isEmpty == false
                              ? CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: CachedNetworkImage(
                                    color: Colors.transparent,
                                    imageUrl: m.avatarUrl!,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    httpHeaders: {
                                      'PRIVATE-TOKEN':
                                          Get.find<SecureStorage>().getToken()
                                    },
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        image: DecorationImage(
                                            image: imageProvider),
                                      ),
                                    ),
                                  ),
                                )
                              : const CircleAvatar(child: Icon(Icons.person)),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m.name!,
                                  style: const TextStyle(fontSize: 18)),
                              Text(m.username!),
                              const SizedBox(height: 5),
                              Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Get.theme.highlightColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5))),
                                  child: Text(
                                      GitlabUtils.getAccessLevelName(
                                          m.accessLevel!),
                                      style: const TextStyle(fontSize: 12))),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      XElevatedButton(
                        child: const Text('Delete member'),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => QuestionMessagePresetsDialog(
                              title: 'Delete member',
                              text: 'Are you sure?',
                              action: () async {
                                await args.onRemove();
                                Get.back();
                              },
                            ),
                          );
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

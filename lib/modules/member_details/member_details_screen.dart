import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gitplus_for_gitlab/api/utils.dart';
import 'package:gitplus_for_gitlab/models/models.dart';
import 'package:gitplus_for_gitlab/shared/shared.dart';
import 'package:intl/intl.dart';

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

    var memberSince = DateFormat('yyyy-MM-dd').format(m.createdAt!);

    return Scaffold(
      appBar: AppBar(
        title: Text(m.name ?? ''),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 1),
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
                                  style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                              Text(m.username!),
                            ],
                          ),
                          const Spacer(),
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
                          const SizedBox(width: 10),
                          Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: m.state == 'active'
                                      ? Colors.green
                                      : Colors.red,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                              child: Text(
                                  m.state! == 'active' ? 'Active' : 'Inactive',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ))),
                        ],
                      ),
                      const Divider(height: 25),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Details',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text('Member since: ',
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(m.createdAt != null
                                    ? memberSince
                                    : ''),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 1),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Actions',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            await args.onRemove();
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Remove member',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
          
        ),
      ),
    );
  }
}

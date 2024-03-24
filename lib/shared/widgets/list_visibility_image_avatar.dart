import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitplus_for_gitlab/models/models.dart';
import 'package:gitplus_for_gitlab/shared/data/secure_storage.dart';

class ListVisibilityImageAvatar extends StatelessWidget {
  final String avatarUrl;
  final String visibility;

  const ListVisibilityImageAvatar(
      {super.key, required this.avatarUrl, required this.visibility});

  @override
  Widget build(BuildContext context) {
    IconData? iconVis;
    if (visibility == GitLabVisibility.private) {
      iconVis = Icons.lock_outline;
    } else if (visibility == GitLabVisibility.internal) {
      iconVis = Icons.lock_outline;
    } else {
      iconVis = Icons.public;
    }
    

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          backgroundColor: Colors.transparent,
          child: CachedNetworkImage(
            placeholder: (context, url) => const CircularProgressIndicator(),
            color: Colors.transparent,
            imageUrl: avatarUrl,
            httpHeaders: {'PRIVATE-TOKEN': Get.find<SecureStorage>().getToken()},
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                image: DecorationImage(image: imageProvider),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -5,
          right: -10,
          child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                  // color: Colors.blue.shade700,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: Icon(
                iconVis,
                // color: Colors.white,
                size: 14,
              )),
        ),
      ],
    );
  }
}

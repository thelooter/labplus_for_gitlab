import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:get/get.dart';
import 'package:labplus_for_gitlab/shared/shared.dart';
import 'package:url_launcher/url_launcher.dart';

import 'about.dart';

class AboutScreen extends GetView<AboutController> {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildWidget());
  }

  Widget _buildWidget() {
    return Scaffold(
      appBar: AppBar(
        title: CrossFade<String>(
          initialData: '',
          data: 'Help & Feedback',
          builder: (value) => Text(value),
        ),
      ),
      body: SafeArea(bottom: false, child: _buildContent()),
    );
  }

  Widget _buildContent() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset("././assets/logo/2.svg", width: 85),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Lab++ for GitLab',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text('v${controller.version.string}',
                      style: const TextStyle(fontSize: 16)),
                ],
              )
            ],
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Octicons.link_external),
          title: const Text('Visit our web page'),
          onTap: () {
            launchUrl(Uri.parse('https://labplus.dev/'));
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.privacy_tip),
          title: const Text('Privacy policy'),
          onTap: () {
            launchUrl(Uri.parse(('https://labplus.dev/privacy-policy/')));
          },
        ),
        const Divider(),
      ],
    );
  }
}

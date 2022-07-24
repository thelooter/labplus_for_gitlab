import 'package:get/get.dart';
import 'package:gitplus_for_gitlab/api/api.dart';
import 'package:gitplus_for_gitlab/shared/data/data.dart';

import 'merge_requests_controller.dart';

class MergeRequestsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MergeRequestsController>(
        () => MergeRequestsController(
              apiRepository: Get.find<ApiRepository>(),
              repository: Get.find<Repository>(),
            ),
        fenix: true);
  }
}

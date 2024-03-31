import 'package:get/get.dart';
import 'package:labplus_for_gitlab/api/api.dart';
import 'package:labplus_for_gitlab/shared/data/data.dart';

import 'milestone_controller.dart';

class MilestoneBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MilestoneController>(
        () => MilestoneController(
              apiRepository: Get.find<ApiRepository>(),
              repository: Get.find<Repository>(),
            ),
        fenix: true);
  }
}

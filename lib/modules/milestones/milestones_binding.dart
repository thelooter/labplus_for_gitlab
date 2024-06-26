import 'package:get/get.dart';
import 'package:labplus_for_gitlab/api/api.dart';
import 'package:labplus_for_gitlab/shared/shared.dart';

import 'milestones_controller.dart';

class MilestonesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MilestonesController>(
        () => MilestonesController(
              apiRepository: Get.find<ApiRepository>(),
              repository: Get.find<Repository>(),
            ),
        fenix: true);
  }
}

import 'package:get/get.dart';
import 'package:gitplus_for_gitlab/api/api.dart';
import 'package:gitplus_for_gitlab/shared/data/data.dart';

import 'project_labels_controller.dart';

class ProjectLabelsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProjectLabelsController>(
        () => ProjectLabelsController(
              apiRepository: Get.find<ApiRepository>(),
              repository: Get.find<Repository>(),
            ),
        fenix: true);
  }
}

import 'package:get/get.dart';
import 'package:labplus_for_gitlab/api/api.dart';
import 'package:labplus_for_gitlab/shared/data/data.dart';

import 'create_project_snippet_controller.dart';

class CreateProjectSnippetBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateProjectSnippetController>(
        () => CreateProjectSnippetController(
              apiRepository: Get.find<ApiRepository>(),
              repository: Get.find<Repository>(),
            ),
        fenix: true);
  }
}

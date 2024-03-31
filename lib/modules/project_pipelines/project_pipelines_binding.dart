import 'package:get/get.dart';
import 'package:labplus_for_gitlab/api/api_repository.dart';
import 'package:labplus_for_gitlab/modules/project_pipelines/project_pipelines.dart';
import 'package:labplus_for_gitlab/shared/data/data.dart';

class PipelinesBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PipelinesController>(
        () => PipelinesController(
            apiRepository: Get.find<ApiRepository>(),
            repository: Get.find<Repository>(),
        ),
        fenix: true);
  }
}

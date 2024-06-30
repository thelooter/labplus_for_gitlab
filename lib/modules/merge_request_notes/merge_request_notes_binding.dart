import 'package:get/get.dart';
import 'package:labplus_for_gitlab/api/api_repository.dart';
import 'package:labplus_for_gitlab/modules/merge_request_notes/merge_request_notes.dart';
import 'package:labplus_for_gitlab/shared/data/repository.dart';

class MergeRequestNotesBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MergeRequestNotesController>(
        () => MergeRequestNotesController(
              apiRepository: Get.find<ApiRepository>(),
              repository: Get.find<Repository>(),
            ),
        fenix: true);
  }
}

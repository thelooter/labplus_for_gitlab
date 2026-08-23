import 'package:get/get.dart';
import 'package:labplus_for_gitlab/api/api_repository.dart';
import 'package:labplus_for_gitlab/modules/merge_request_notes/merge_request_notes.dart';
import 'package:labplus_for_gitlab/shared/data/repository.dart';
import 'package:labplus_for_gitlab/routes/route_args.dart';

class MergeRequestNotesBindings extends Bindings {
  @override
  void dependencies() {
    // Captured here, not inside the lazyPut closure: fenix means that
    // closure can run again after the route has moved on.
    final args = Get.arguments as MergeRequestArgs;
    Get.lazyPut<MergeRequestNotesController>(
        () => MergeRequestNotesController(
              apiRepository: Get.find<ApiRepository>(),
              repository: Get.find<Repository>(),
              args: args,
            ),
        fenix: true);
  }
}

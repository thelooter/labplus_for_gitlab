import 'package:get/get.dart';
import 'package:labplus_for_gitlab/api/api.dart';
import 'package:labplus_for_gitlab/routes/route_args.dart';
import 'package:labplus_for_gitlab/shared/data/data.dart';

import 'edit_issue_controller.dart';

class EditIssueBinding implements Bindings {
  @override
  void dependencies() {
    // Captured here, not inside the lazyPut closure: fenix means that
    // closure can run again after the route has moved on.
    final args = Get.arguments as IssueArgs;
    Get.lazyPut<EditIssueController>(
        () => EditIssueController(
              apiRepository: Get.find<ApiRepository>(),
              repository: Get.find<Repository>(),
              args: args,
            ),
        fenix: true);
  }
}

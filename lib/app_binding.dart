import 'package:labplus_for_gitlab/api/api.dart';
import 'package:get/get.dart';
import 'package:labplus_for_gitlab/shared/shared.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // SecureStorage and the spinner observer are handed to the provider here
    // rather than fetched inside it, so the transport layer has no opinion
    // about how it was constructed. See BaseProvider.
    Get.put(
      ApiProvider(
        storage: Get.find<SecureStorage>(),
        observer: const EasyLoadingApiObserver(),
      ),
      permanent: true,
    );
    Get.put(ApiRepository(apiProvider: Get.find<ApiProvider>()),
        permanent: true);

    Get.put(Repository(), permanent: true);
  }
}

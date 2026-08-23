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
        observer: EasyLoadingApiObserver(),
      ),
      permanent: true,
    );
    Get.put(ApiRepository(apiProvider: Get.find<ApiProvider>()),
        permanent: true);

    // The bus is registered separately from Repository, not owned by it:
    // phase 4 makes Repository binding-scoped so it dies on leaving a feature,
    // and the event stream has to outlive that.
    Get.put(DomainEvents(), permanent: true);
    Get.put(Repository(events: Get.find<DomainEvents>()), permanent: true);
  }
}

import 'package:dio/dio.dart' as d;
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:labplus_for_gitlab/shared/shared.dart';

class BaseProvider {
  late d.Dio dio;

  static var loading = false.obs;

  BaseProvider() {
    final data = Get.find<SecureStorage>();

    dio = d.Dio();

    const timeout = Duration(milliseconds: 8000);

    dio.options = BaseOptions(
      connectTimeout: timeout,
      sendTimeout: timeout,
      receiveTimeout: timeout,
    );

    dio.interceptors.add(d.InterceptorsWrapper(
      onRequest: (req, handler) async {
        loading.value = true;

        if (data.getToken().isNotEmpty) {
          var token = data.getToken();
          req.headers['Authorization'] = 'Bearer $token';
        }
        req.baseUrl = data.getBaseurl();
        return handler.next(req);
      },
      onResponse: (res, handler) {
        EasyLoading.dismiss();
        loading.value = false;

        if (!okStatusCodes.contains(res.statusCode)) {
          CommonWidget.toast("An error occured");
        }
        return handler.next(res);
      },
      onError: (e, handler) {
        EasyLoading.dismiss();
        loading.value = false;
        return handler.next(e);
      },
    ));
  }

  var okStatusCodes = [200, 201, 202, 204];
}

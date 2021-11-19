import 'package:balloon/models/user.dart';
import 'package:balloon/routes/router_tables.dart';
import 'package:balloon/view_models/app_provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';

class HttpRequest {
  // Request base path
  String baseURL = "";
  Map headers = {};

  setHeader(Map opts) {
    headers = opts;
  }

  handleStatusCode(int code, {bool? widthout401}) {
    switch (code) {
      case 401:
        User.removeToken();
        if (widthout401 == false) {
          EasyLoading.showError('请重新登录');
          AppProvider.navigatorKey.currentState!
              .pushReplacementNamed(RouterTables.loginPath);
        }
        break;
      case 403:
        EasyLoading.showInfo('没有访问权限');
        break;
    }
  }

  request(
    Uri url, {
    String? method = 'GET',
    Map? headers,
    Map? body,
    bool? widthout401 = false,
  }) async {
    switch (method) {
      case 'GET':
        Response res = await get(
          url,
          headers: {...?headers},
        );
        handleStatusCode(res.statusCode);
        return res;
      case 'POST':
        Response res = await post(
          url,
          body: {...?body},
          headers: {...?headers},
        );
        handleStatusCode(res.statusCode, widthout401: widthout401);
        return res;
      default:
        return;
    }
  }
}

import 'dart:convert';

import 'package:balloon/models/user.dart';
import 'package:balloon/routes/router_tables.dart';
import 'package:balloon/view_models/app_provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:http/http.dart';
import 'package:dio/dio.dart';

class HttpRequest {
  late Dio dio;

  HttpRequest(BaseOptions baseOptions) {
    dio = Dio(baseOptions);
  }

  handleStatusCode(dynamic res, {bool? widthout401}) {
    var body = res.data;

    switch (res.statusCode) {
      case 400:
        EasyLoading.showToast(body['message']);
        break;
      case 401:
        User.removeToken();

        if (widthout401 == false) {
          String message = body['message'] == 'Invalid credentials'
              ? '需要登录'
              : body['message'];
          EasyLoading.showToast(message);
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
    String url, {
    String? method = 'GET',
    Map? headers,
    Map<String, dynamic>? params,
    Map<String, dynamic>? data,
    bool? widthout401 = false,
  }) async {
    switch (method) {
      case 'GET':
        try {
          Response res = await dio.get(
            url,
            queryParameters: {...?params},
            options: Options(
              headers: {...?headers},
            ),
          );
          return res;
        } on DioError catch (e) {
          handleStatusCode(e.response, widthout401: widthout401);
        }
        break;
      case 'POST':
        try {
          Response res = await dio.post(
            url,
            queryParameters: {...?params},
            data: {...?data},
            options: Options(
              headers: {...?headers},
            ),
          );
          return res;
        } on DioError catch (e) {
          handleStatusCode(e.response, widthout401: widthout401);
        }
        break;
      case 'PUT':
        try {
          Response res = await dio.put(
            url,
            queryParameters: {...?params},
            data: {...?data},
            options: Options(
              headers: {...?headers},
            ),
          );
          return res;
        } on DioError catch (e) {
          handleStatusCode(e.response, widthout401: widthout401);
        }
        break;
      case 'DELETE':
        try {
          Response res = await dio.delete(
            url,
            queryParameters: {...?params},
            data: {...?data},
            options: Options(
              headers: {...?headers},
            ),
          );
          return res;
        } on DioError catch (e) {
          handleStatusCode(e.response, widthout401: widthout401);
        }
        break;
      default:
        return;
    }
  }
}

// class HttpRequest {
//   // Request base path
//   String baseURL = "";
//   Map headers = {};

//   setHeader(Map opts) {
//     headers = opts;
//   }

//   request(
//     Uri url, {
//     String? method = 'GET',
//     Map? headers,
//     Map? body,
//     bool? widthout401 = false,
//   }) async {
//     switch (method) {
//       case 'GET':
//         Response res = await get(
//           url,
//           headers: {...?headers},
//         );
//         handleStatusCode(res);
//         return res;
//       case 'POST':
//         Response res = await post(
//           url,
//           body: {...?body},
//           headers: {...?headers},
//         );
//         handleStatusCode(res, widthout401: widthout401);
//         return res;
//       case 'PUT':
//         try {
//           Response res = await put(
//             url,
//             body: {...?body},
//             headers: {...?headers},
//           );
//           handleStatusCode(res, widthout401: widthout401);
//           return res;
//         } catch (err) {
//           print(err);
//         }
//         break;
//       case 'DELETE':
//         Response res = await delete(
//           url,
//           body: {...?body},
//           headers: {...?headers},
//         );
//         handleStatusCode(res, widthout401: widthout401);
//         return res;
//       default:
//         return;
//     }
//   }
// }

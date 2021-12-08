import 'package:balloon/service/http_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:balloon/util/enum/api_request_status.dart';

class ExploreProvider with ChangeNotifier {
  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;
  int page = 1;
  List explores = [];
  bool hasMore = true;

  changeScreenLoading() {
    apiRequestStatus = APIRequestStatus.loading;
    notifyListeners();
  }

  changeScreenLoaded() {
    apiRequestStatus = APIRequestStatus.loaded;
    notifyListeners();
  }

  void setApiRequestStatus(APIRequestStatus value) {
    apiRequestStatus = value;
    notifyListeners();
  }

  getExplores() async {
    if (apiRequestStatus == APIRequestStatus.loading) {
      Response res = await HttpService.getExploreData(page);

      if (res.statusCode == 200) {
        var body = res.data;

        if (body['users'] == null) {
          explores = [...explores];
        } else {
          explores = [...explores, ...body['users']];
          if (body['users'].length == 0) {
            hasMore = false;
          }
        }
      }

      changeScreenLoaded();
    }
  }

  getExploresByFirstPage() async {
    if (apiRequestStatus == APIRequestStatus.loading) {
      page = 1;
      explores = [];
      hasMore = true;
    }
  }
}

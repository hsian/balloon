import 'package:balloon/service/http_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:balloon/util/enum/api_request_status.dart';

class ExploreProvider with ChangeNotifier {
  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;
  int page = 1;
  List explores = [];

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

  getExplores(currentPage) async {
    if (apiRequestStatus == APIRequestStatus.loading) {
      List value = await HttpService.getExploreData(currentPage);
      explores = value;
      changeScreenLoaded();
    }

    return explores;
  }
}

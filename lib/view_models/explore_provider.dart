import 'package:balloon/service/http_service.dart';
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
      List value = (await HttpService.getExploreData(page)) as List;
      explores = [...explores, ...value];
      if (value.length == 0) {
        hasMore = false;
      }
      changeScreenLoaded();
    }
  }

  getWordsByFirstPage() async {
    if (apiRequestStatus == APIRequestStatus.loading) {
      page = 1;
      explores = [];
      hasMore = true;
      await getExplores();
    }
  }
}

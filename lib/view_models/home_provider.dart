import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:balloon/util/enum/api_request_status.dart';

class HomeProvider with ChangeNotifier, DiagnosticableTreeMixin {
  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;

  getFeeds() async {
    setApiRequestStatus(APIRequestStatus.loading);

    changeScreenLoaded();
  }

  changeScreenLoaded() {
    new Timer(Duration(milliseconds: 100), () {
      apiRequestStatus = APIRequestStatus.loaded;
      notifyListeners();
    });
    // apiRequestStatus = APIRequestStatus.loaded;
    // notifyListeners();
  }

  void setApiRequestStatus(APIRequestStatus value) {
    apiRequestStatus = value;
    notifyListeners();
  }
}

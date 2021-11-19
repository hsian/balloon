import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:balloon/models/user.dart';
import 'package:balloon/service/http_service.dart';
import 'package:balloon/util/enum/api_request_status.dart';

class UserProvider with ChangeNotifier {
  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;
  Map user = {"nickname": ""};
  bool existUserInfo = false;

  void setUser(data) {
    user = data;
    notifyListeners();
  }

  void setUserEmpty() {
    user = {"nickname": ""};
    existUserInfo = false;
    apiRequestStatus = APIRequestStatus.loading;
    User.removeToken();
    notifyListeners();
  }

  changeScreenLoaded() {
    apiRequestStatus = APIRequestStatus.loaded;
    notifyListeners();
  }

  getUserInfo() async {
    if (apiRequestStatus == APIRequestStatus.loading) {
      try {
        Map res = await HttpService.getUserInfo(widthout401: true);
        user = res['data'];
        existUserInfo = true;
        changeScreenLoaded();
      } catch (err) {
        changeScreenLoaded();
      }
    }
  }
}

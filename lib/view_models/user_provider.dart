import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:balloon/models/user.dart';
import 'package:balloon/service/http_service.dart';
import 'package:balloon/util/enum/api_request_status.dart';

class UserProvider with ChangeNotifier {
  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;
  Map user = {
    "nickname": "",
    "gender": 1,
  };
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

  login(Map data) async {
    if (apiRequestStatus == APIRequestStatus.loading) {
      try {
        Response res = await HttpService.login(data);
        final body = res.data;

        if (res.statusCode == 200) {
          user = body['data'];
          User.setToken(body['token']);
          existUserInfo = true;
          changeScreenLoaded();
        }
        return res;
      } catch (err) {
        print(err);
        changeScreenLoaded();
      }
    }
  }

  register(Map data) async {
    if (apiRequestStatus == APIRequestStatus.loading) {
      try {
        Response res = await HttpService.register(data);
        final body = res.data;

        if (res.statusCode == 200) {
          user = body['data'];
          User.setToken(body['token']);
          existUserInfo = true;
          changeScreenLoaded();
        }

        return res;
      } catch (err) {
        print(err);
        changeScreenLoaded();
      }
    }
  }

  getUserInfo() async {
    if (apiRequestStatus == APIRequestStatus.loading) {
      try {
        Response res = await HttpService.getUserInfo(widthout401: true);

        if (res.statusCode == 200) {
          user = res.data['data'];
          existUserInfo = true;
          changeScreenLoaded();
        }
      } catch (err) {
        print(err);
        changeScreenLoaded();
      }
    }
  }

  updateUserProfile(Map data) async {
    if (apiRequestStatus == APIRequestStatus.loading) {
      try {
        Response res = await HttpService.updateUserProfile(data);
        if (res.statusCode == 200) {
          setUser(res.data['user']);
          changeScreenLoaded();
        }
        return res;
      } catch (err) {
        changeScreenLoaded();
      }
    }
  }
}

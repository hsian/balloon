import 'dart:async';

import 'package:balloon/util/enum/api_request_status.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:balloon/service/http_service.dart';

class WordProvider with ChangeNotifier {
  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;
  int page = 1;
  List words = [];
  int count = 0;
  bool hasMore = true;

  changeScreenLoaded() {
    apiRequestStatus = APIRequestStatus.loaded;
    notifyListeners();
  }

  getWords() async {
    if (apiRequestStatus == APIRequestStatus.loading) {
      Response res = await HttpService.getPersonalWords(page);
      final data = res.data;

      if (res.statusCode == 200) {
        count = data['count'];
        if (data['data'] == null) {
          words = [...words];
        } else {
          words = [...words, ...data['data']];
          if (data['data'].length == 0) {
            hasMore = false;
          }
        }
      }
      changeScreenLoaded();
    }
  }

  getWordsByFirstPage() {
    if (apiRequestStatus == APIRequestStatus.loading) {
      page = 1;
      words = [];
      hasMore = true;
    }
  }

  getWordByKeyword(value) async {
    if (apiRequestStatus != APIRequestStatus.loading) {
      apiRequestStatus = APIRequestStatus.loading;
      Response res = await HttpService.getWordByKeyword(value);
      apiRequestStatus = APIRequestStatus.loaded;
      return res.data['data'];
    }
  }

  postWordById(id) async {
    if (apiRequestStatus != APIRequestStatus.loading) {
      apiRequestStatus = APIRequestStatus.loading;
      Response res = await HttpService.postWordById(id);
      apiRequestStatus = APIRequestStatus.loaded;
      return res;
    }
  }

  deleteWordById(id) async {
    if (apiRequestStatus != APIRequestStatus.loading) {
      apiRequestStatus = APIRequestStatus.loading;
      Response res = await HttpService.deleteWordById(id);
      apiRequestStatus = APIRequestStatus.loaded;
      return res;
    }
  }

  deleteWordByIndex(index) async {
    final wordCache = [...words];
    words = [];

    new Timer(Duration(milliseconds: 100), () async {
      wordCache.removeAt(index);
      words = wordCache;
      changeScreenLoaded();
    });
  }
}

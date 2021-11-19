import 'package:balloon/util/enum/api_request_status.dart';
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
      Map res = await HttpService.getPersonalWords(page);
      count = res['count'];
      words = [...words, ...res['data']];
      if (res['data'].length == 0) {
        hasMore = false;
      }
      changeScreenLoaded();
    }
  }

  getWordsByFirstPage() async {
    if (apiRequestStatus == APIRequestStatus.loading) {
      page = 1;
      words = [];
      hasMore = true;
      await getWords();
    }
  }

  getWordByKeyword(value) async {
    if (apiRequestStatus != APIRequestStatus.loading) {
      apiRequestStatus = APIRequestStatus.loading;
      Map res = await HttpService.getWordByKeyword(value);
      apiRequestStatus = APIRequestStatus.loaded;
      return res['data'];
    }
  }

  postWordById(id) async {
    if (apiRequestStatus != APIRequestStatus.loading) {
      apiRequestStatus = APIRequestStatus.loading;
      Map res = await HttpService.postWordById(id);
      apiRequestStatus = APIRequestStatus.loaded;
      return res;
    }
  }
}

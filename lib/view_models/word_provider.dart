import 'package:balloon/util/enum/api_request_status.dart';
import 'package:flutter/foundation.dart';
import 'package:balloon/service/http_service.dart';

class WordProvider with ChangeNotifier {
  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;
  int page = 1;
  List words = [];
  int count = 0;

  changeScreenLoaded() {
    apiRequestStatus = APIRequestStatus.loaded;
    notifyListeners();
  }

  getWords() async {
    if (apiRequestStatus == APIRequestStatus.loading) {
      Map res = await HttpService.getPersonalWords(page);
      count = res['count'];
      words = res['data'];
      changeScreenLoaded();
    }
  }
}

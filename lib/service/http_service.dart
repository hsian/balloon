import 'dart:convert';
import 'package:balloon/models/user.dart';
import 'package:http/http.dart';
import 'package:balloon/service/http_request.dart';

class HttpService {
  static final String baseURL = "http://192.168.1.115:5000";
  static HttpRequest httpRequest = new HttpRequest();

  // 登录
  static Future<Map> login() async {
    var url = Uri.parse(baseURL + '/api/login/');
    Response res =
        await httpRequest.request(url, method: "POST", body: {"id": "1"});

    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      // user info
      var user = body['data'];
      User.setToken(body['token']);

      return user;
    } else {
      throw "登录失败.";
    }
  }

  // 获取个人信息
  static Future<Map> getUserInfo({bool? widthout401}) async {
    var url = Uri.parse(baseURL + '/api/user_info/');
    var token = await User.getToken();

    Response res = await httpRequest.request(
      url,
      method: "GET",
      headers: {"Authorization": "Bearer $token"},
      widthout401: widthout401,
    );

    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);

      return body;
    } else {
      throw "获取个人信息失败.";
    }
  }

  // 获取浏览页的数据列表
  static Future<List> getExploreData(int page) async {
    var url = Uri.parse(baseURL + '/api/users/?page=$page');
    Response res = await httpRequest.request(url, method: "GET");

    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);

      if (body['users'] == null) {
        return [];
      } else {
        return body['users'];
      }
    } else {
      throw "获取浏览页数据失败.";
    }
  }

  // 获取单词列表
  static Future<Map> getPersonalWords(int page) async {
    var url = Uri.parse(baseURL + '/api/words/?page=$page');
    var token = await User.getToken();

    Response res = await httpRequest
        .request(url, headers: {"Authorization": "Bearer $token"});

    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);

      return body;
    } else {
      throw "获取单词列表失败.";
    }
  }

  // 获取单词音频
  static Future<Map> getAudioByKeyword(String keyword) async {
    var url =
        Uri.parse(baseURL + '/api/word_audio_by_keyword/?keyword=$keyword');
    var token = await User.getToken();

    Response res = await httpRequest
        .request(url, headers: {"Authorization": "Bearer $token"});

    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);

      return body;
    } else {
      throw "获取单词音频失败.";
    }
  }

  // 根据关键字翻译单词
  static Future<Map> getWordByKeyword(String keyword) async {
    var url = Uri.parse(baseURL + '/api/words_yd_trans/?q=$keyword');
    var token = await User.getToken();

    Response res = await httpRequest
        .request(url, headers: {"Authorization": "Bearer $token"});

    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);

      return body;
    } else {
      throw "关键字翻译单词失败.";
    }
  }

  // 新增单词
  static Future<Map> postWordById(int id) async {
    var url = Uri.parse(baseURL + '/api/words_by_id/?id=$id');
    var token = await User.getToken();

    Response res = await httpRequest
        .request(url, headers: {"Authorization": "Bearer $token"});

    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);

      return body;
    } else {
      throw "新增单词失败.";
    }
  }
}

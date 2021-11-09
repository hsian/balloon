import 'dart:convert';
import 'package:http/http.dart';
import 'package:balloon/models/user.dart';

class HttpService {
  static final String baseURL = "http://192.168.1.123:5000";

  static Future<User> login() async {
    var url = Uri.parse(baseURL + '/api/login/');
    Response res = await post(url, body: {"id": "1"});

    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      var info = body['data'];
      var userInfo = UserInfo(
        avatarUrl: info['avatarUrl'],
        gender: info['gender'],
        id: info['id'],
        last_seen: info['last_seen'],
        nickname: info['nickname'],
        phone: info['phone'],
        username: info['username'],
      );

      User user = User(token: body['token'], data: userInfo);
      user.setToken(user.token);

      return user;
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  // 获取浏览页的数据列表
  static Future<List> getExploreData(int page) async {
    print(baseURL + '/api/users/?page=$page');
    var url = Uri.parse(baseURL + '/api/users/?page=$page');
    Response res = await get(url);

    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);

      if (body['users'] == null) {
        return [];
      } else {
        return body['users'];
      }
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  // 获取单词列表
  static Future<Map> getPersonalWords(int page) async {
    var url = Uri.parse(baseURL + '/api/words/?page=$page');
    var token = await User.getToken();

    Response res = await get(url, headers: {"Authorization": "Bearer $token"});

    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);

      return body;
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  // 获取单词音频
  static Future<Map> getAudioByKeyword(String keyword) async {
    var url =
        Uri.parse(baseURL + '/api/word_audio_by_keyword/?keyword=$keyword');
    var token = await User.getToken();

    Response res = await get(url, headers: {"Authorization": "Bearer $token"});

    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);

      return body;
    } else {
      throw "Unable to retrieve audio.";
    }
  }

  // 根据关键字翻译单词
  static Future<Map> getWordByKeyword(String keyword) async {
    var url = Uri.parse(baseURL + '/api/words_yd_trans/?q=$keyword');
    var token = await User.getToken();

    Response res = await get(url, headers: {"Authorization": "Bearer $token"});

    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);

      return body;
    } else {
      throw "Unable to retrieve word.";
    }
  }

  static Future<Map> postWordById(int id) async {
    var url = Uri.parse(baseURL + '/api/words_by_id/?id=$id');
    var token = await User.getToken();

    Response res = await get(url, headers: {"Authorization": "Bearer $token"});

    var body = jsonDecode(res.body);
    return body;
  }
}

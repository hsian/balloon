import 'package:balloon/models/user.dart';
import 'package:dio/dio.dart';
import 'package:balloon/service/http_request.dart';

class HttpService {
  // static final String baseURL = "http://192.168.1.116:5000";
  static final String baseURL = "http://49.234.206.77:8997";

  static HttpRequest httpRequest = new HttpRequest(
    BaseOptions(
      baseUrl: baseURL,
    ),
  );

  // 登录
  static Future<Response> login(Map data) async {
    Response res = await httpRequest.request(
      '/api/login/',
      method: "POST",
      data: {...data},
    );

    return res;
  }

  // 注册
  static Future<Response> register(Map data) async {
    Response res = await httpRequest.request(
      '/api/register/',
      method: "POST",
      data: {...data},
    );
    return res;
  }

  // 获取个人信息
  static Future<Response> getUserInfo({bool? widthout401}) async {
    var token = await User.getToken();

    Response res = await httpRequest.request(
      '/api/user_info/',
      method: "GET",
      headers: {"Authorization": "Bearer $token"},
      widthout401: widthout401,
    );

    return res;
  }

  // 获取浏览页的数据列表
  static Future<Response> getExploreData(int page) async {
    Response res = await httpRequest.request(
      '/api/users/?page=$page',
      method: "GET",
    );

    return res;
  }

  // 获取单词列表
  static Future<Response> getPersonalWords(int page) async {
    var token = await User.getToken();

    Response res = await httpRequest.request(
      '/api/words/?page=$page',
      headers: {"Authorization": "Bearer $token"},
    );

    return res;
  }

  // 获取单词音频
  static Future<Response> getAudioByKeyword(String keyword) async {
    var token = await User.getToken();

    Response res = await httpRequest.request(
      '/api/word_audio_by_keyword/?keyword=$keyword',
      headers: {"Authorization": "Bearer $token"},
    );

    return res;
  }

  // 根据关键字翻译单词
  static Future<Response> getWordByKeyword(String keyword) async {
    var token = await User.getToken();

    Response res = await httpRequest.request(
      '/api/words_yd_trans/?q=$keyword',
      headers: {"Authorization": "Bearer $token"},
    );

    return res;
  }

  // 新增单词
  static Future<Response> postWordById(int id) async {
    var token = await User.getToken();

    Response res = await httpRequest.request(
      '/api/words_by_id/?id=$id',
      headers: {"Authorization": "Bearer $token"},
    );

    return res;
  }

  // 删除单词
  static Future<Response> deleteWordById(int id) async {
    var token = await User.getToken();

    Response res = await httpRequest.request(
      '/api/word_remove_by_id/?id=$id',
      headers: {"Authorization": "Bearer $token"},
    );

    return res;
  }

  // 修改个人信息
  static Future<Response> updateUserProfile(Map data) async {
    var token = await User.getToken();

    Response res = await httpRequest.request(
      '/api/user/',
      headers: {"Authorization": "Bearer $token"},
      method: "PUT",
      data: {
        'gender': data['gender'],
        'nickname': data['nickname'],
      },
    );

    return res;
  }
}

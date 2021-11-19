import 'dart:ffi';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  dynamic avatarUrl;
  dynamic gender;
  int? id;
  // ignore: non_constant_identifier_names
  String? last_seen;
  String nickname;
  dynamic phone;
  String? username;

  UserInfo({
    this.avatarUrl,
    this.gender,
    this.id,
    // ignore: non_constant_identifier_names
    this.last_seen,
    required this.nickname,
    this.phone,
    this.username,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      avatarUrl: json['avatarUrl'],
      gender: json['avatarUrl'],
      id: json['id'],
      last_seen: json['last_seen'],
      nickname: json['nickname'],
      phone: json['phone'],
      username: json['username'],
    );
  }
}

class User {
  UserInfo? data;
  Double? expiration;
  String? message;
  String token;

  User({
    this.data,
    this.expiration,
    this.message,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      data: UserInfo.fromJson(json['data']),
      expiration: json['expiration'],
      message: json['message'],
      token: json['token'],
    );
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static setToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', value);
  }

  static removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<bool> isAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic value =
        prefs.getString('token') != null ? prefs.getString('token') : "";
    return value!.isNotEmpty;
  }
}

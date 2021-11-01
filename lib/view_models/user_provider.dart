import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:balloon/models/user.dart';

class UserProvider with ChangeNotifier {
  User user = new User(
    token: "",
    data: new UserInfo(nickname: ""),
  );

  void setUser(value) {
    user = value;
    notifyListeners();
  }

  void setUserEmpty() {
    this.user.data = new UserInfo(
      nickname: "",
    );
    this.user.token = "";
    this.user.removeToken();
    notifyListeners();
  }
}

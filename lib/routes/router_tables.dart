import 'package:balloon/views/change_profile/change_profile.dart';
import 'package:flutter/material.dart';
import 'package:balloon/views/home/home.dart';
import 'package:balloon/views/login/login.dart';
import 'package:balloon/views/explore/explore.dart';
import 'package:balloon/views/word/word.dart';
import 'package:balloon/views/profile/profile.dart';
import 'package:balloon/views/splash/splash.dart';
import 'package:balloon/views/main_screen.dart';
import 'package:balloon/models/user.dart';

class RouterTables {
  static const String mainPath = 'main';
  static const String splashPath = 'splash';
  static const String homePath = 'home';
  static const String loginPath = 'login';
  static const String explorePath = 'explore';
  static const String wordPath = 'word';
  static const String profilePath = 'profile';
  static const String changeProfilePath = 'change_profile';

  static Map<String, WidgetBuilder> routesMap = {
    mainPath: (context) => MainScreen(),
    splashPath: (context) => Splash(),
    homePath: (context) => Home(),
    loginPath: (context) => Login(),
    explorePath: (context) => Explore(),
    wordPath: (context) => Word(),
    profilePath: (context) => Profile(),
    changeProfilePath: (context) => ChangeProfile(),
  };

  static authFailHandle(context) {
    User.isAuth().then((value) {
      if (value == false) {
        Navigator.pushReplacementNamed(context, loginPath);
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  // 路由拦截
  static Route onGenerateRoute<T extends Object>(RouteSettings settings) {
    return MaterialPageRoute<T>(
      settings: settings,
      builder: (context) {
        String? name = settings.name;
        WidgetBuilder? page = routesMap[name];

        switch (name) {
          case loginPath:
            User.isAuth().then((value) {
              if (value) {
                Navigator.pushReplacementNamed(context, mainPath);
              }
            });
            break;
          case wordPath:
            authFailHandle(context);
            break;
        }

        return page!(context);

        // return Scaffold(
        //   body: Center(
        //     child: Text('页面不存在'),
        //   ),
        // );
      },
    );
  }
}

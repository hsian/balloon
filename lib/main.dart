import 'dart:io';

import 'package:balloon/view_models/explore_provider.dart';
import 'package:balloon/view_models/word_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import 'package:balloon/util/consts.dart';
import 'package:balloon/theme/theme_config.dart';
import 'package:balloon/view_models/app_provider.dart';
import 'package:balloon/view_models/home_provider.dart';
import 'package:balloon/view_models/user_provider.dart';
import 'package:balloon/views/splash/splash.dart';
import 'package:balloon/routes/router_tables.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ExploreProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => WordProvider()),
      ],
      child: MyApp(),
    ),
  );

  if (Platform.isAndroid) {
    SystemUiOverlayStyle style = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,

        ///这是设置状态栏的图标和字体的颜色
        ///Brightness.light  一般都是显示为白色
        ///Brightness.dark 一般都是显示为黑色
        statusBarIconBrightness: Brightness.dark);
    SystemChrome.setSystemUIOverlayStyle(style);
  }
}

class MyApp extends StatelessWidget {
  // final appProvider = new AppProvider();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (BuildContext context, AppProvider appProvider, child) {
        return MaterialApp(
          key: appProvider.key,
          debugShowCheckedModeBanner: false,
          navigatorKey: AppProvider.navigatorKey,
          title: Constants.appName,
          theme: themeData(appProvider.theme),
          darkTheme: themeData(ThemeConfig.darkTheme),
          home: Splash(),
          initialRoute: RouterTables.splashPath,
          // routes: RouterTables.routesMap,
          onGenerateRoute: RouterTables.onGenerateRoute,
          builder: EasyLoading.init(),
        );
      },
    );
  }

  // Apply font to our app's theme
  ThemeData themeData(ThemeData theme) {
    // return theme.copyWith(
    //   textTheme: GoogleFonts.sourceSansProTextTheme(
    //     theme.textTheme,
    //   ),
    // );
    return theme;
  }
}

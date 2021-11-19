import 'package:balloon/components/body_builder.dart';
import 'package:balloon/components/loading_widget.dart';
import 'package:balloon/routes/router_tables.dart';
import 'package:balloon/util/enum/api_request_status.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:balloon/view_models/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:balloon/view_models/app_provider.dart';
import 'package:balloon/theme/theme_config.dart';
import 'package:provider/provider.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

Map actions = {
  "login": {
    'icon': FeatherIcons.logIn,
    'label': '去登录',
  },
  "theme": {
    'icon': FeatherIcons.lifeBuoy,
    'label': '主题',
  },
  "settings": {
    'icon': FeatherIcons.settings,
    'label': '设置',
  },
  "logout": {
    'icon': FeatherIcons.logOut,
    'label': '退出登录',
  }
};

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late List items;
  late UserProvider userProviderCache;

  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  List resetItems(UserProvider userProvider) {
    List items = [];

    if (userProvider.existUserInfo == false) {
      items = [
        actions['login'],
        actions['theme'],
      ];
    } else {
      items = [
        actions['settings'],
        actions['theme'],
        actions['logout'],
      ];
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (BuildContext context, UserProvider userProvider, child) {
        userProviderCache = userProvider;
        items = resetItems(userProvider);

        return Scaffold(
          body: BodyBuilder(
            apiRequestStatus: userProvider.apiRequestStatus,
            reload: () => userProvider.getUserInfo(),
            child: FutureBuilder(
              future: userProvider.getUserInfo(),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    _buildProfile(userProvider),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildCellBar(userProvider, items[index]);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfile(UserProvider userProvider) {
    return Offstage(
      offstage: !userProvider.existUserInfo,
      child: Container(
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 30, bottom: 0),
        child: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            new ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://img14.360buyimg.com/ceco/s300x300_jfs/t1/96894/2/8726/522292/5e07663aE99a1f3a7/50c33370b8c790a8.jpg!q70.jpg',
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Text(
                userProvider.user['nickname'],
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCellBar(UserProvider userProvider, Map item) {
    return InkWell(
      onTap: () {
        if (item['label'] == actions['login']['label']) {
          userProviderCache.apiRequestStatus = APIRequestStatus.loading;
          Navigator.pushNamed(context, RouterTables.loginPath);
          return;
        }
        if (item['label'] == actions['settings']['label']) {
          Navigator.pushNamed(context, RouterTables.changeProfilePath);
          return;
        }
        if (item['label'] == actions['logout']['label']) {
          userProvider.setUserEmpty();
          EasyLoading.showSuccess('退出成功!');
          userProviderCache.apiRequestStatus = APIRequestStatus.loading;
          Navigator.pushNamed(context, RouterTables.mainPath);
          return;
        }
      },
      child: Container(
        height: 62,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item['icon'],
              size: 22,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                item['label'],
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline6?.color,
                  fontSize: 16,
                ),
              ),
            ),
            _buildLeading(item)
          ],
        ),
      ),
    );
  }

  Widget _buildLeading(Map item) {
    if (item['label'] == '主题') {
      return Switch(
        value: Provider.of<AppProvider>(context).theme == ThemeConfig.lightTheme
            ? false
            : true,
        onChanged: (v) {
          if (v) {
            Provider.of<AppProvider>(context, listen: false)
                .setTheme(ThemeConfig.darkTheme, 'dark');
          } else {
            Provider.of<AppProvider>(context, listen: false)
                .setTheme(ThemeConfig.lightTheme, 'light');
          }
        },
      );
    }

    return Icon(
      Icons.keyboard_arrow_right,
      size: 26,
      color: Color.fromRGBO(150, 150, 150, 1),
    );
  }
}

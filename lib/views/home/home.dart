import 'package:flutter/material.dart';
import 'package:balloon/components/body_builder.dart';
import 'package:balloon/view_models/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:balloon/routes/router_tables.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<HomeProvider>(
      builder: (BuildContext context, HomeProvider homeProvider, child) {
        return Scaffold(
          body: _buildBody(homeProvider),
        );
      },
    );
  }

  Widget _buildBody(HomeProvider homeProvider) {
    return BodyBuilder(
      apiRequestStatus: homeProvider.apiRequestStatus,
      child: _buildBodyList(homeProvider),
      reload: () => homeProvider.getFeeds(),
    );
  }

  Widget _buildBodyList(HomeProvider homeProvider) {
    homeProvider.changeScreenLoaded();

    return RefreshIndicator(
        onRefresh: () => homeProvider.getFeeds(),
        child: Stack(
          children: [
            ListView(
              children: <Widget>[
                Image.network(
                  'https://img.wenjutv.net/questions/20190318/fd57630c3b3a20cba6e6bf6ce1057fad.jpg',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 30.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "It's about how hard you can get hit and keep moving forward, How much you can take and keep moving forward.",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 15.0),
                      Text(
                        "你能承受多少并且能一直向前",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _buildWordNavigator(),
          ],
        ));
  }

  Widget _buildWordNavigator() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 60,
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {},
              child: ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                  ),
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).backgroundColor,
                  ),
                  side: MaterialStateProperty.all(
                    BorderSide(
                      width: 2,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35))),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    RouterTables.wordPath,
                  );
                },
                child: Text(
                  '我的词库',
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.headline6?.color),
                ),
              ),
            )
            // new RaisedButton(
            //   child: new Text(
            //     '我的单词',
            //     style: TextStyle(fontSize: 22),
            //   ),
            //   onPressed: () {
            //     MyRouter.pushPage(
            //       context,
            //       // Word(),
            //       Login(),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

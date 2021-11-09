import 'package:balloon/components/body_builder.dart';
import 'package:flutter/material.dart';
import 'package:balloon/view_models/explore_provider.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with AutomaticKeepAliveClientMixin {
  //final homeProvider = new HomeProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Consumer<ExploreProvider>(
      builder: (BuildContext context, ExploreProvider exploreProvider, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(
              '浏览',
              style: TextStyle(fontSize: 18),
            ),
          ),
          body: BodyBuilder(
            apiRequestStatus: exploreProvider.apiRequestStatus,
            reload: () => exploreProvider.getExplores(exploreProvider.page),
            child: RefreshIndicator(
              onRefresh: () =>
                  exploreProvider.getExplores(exploreProvider.page),
              child: _buildBodyList(exploreProvider),
            ),
          ),
        );
      },
    );
  }

  _buildBodyList(exploreProvider) {
    return FutureBuilder(
      future: exploreProvider.getExplores(exploreProvider.page),
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: exploreProvider.explores.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                SizedBox(
                  height: 1,
                ),
                _buildStatsItem(exploreProvider.explores[index]),
              ],
            );
          },
        );
      },
    );
  }

  _buildStatsItem(item) {
    final formatter = DateFormat('EEE, d MMM yyyy HH:mm:ss');
    final lastSeen = formatter.parse(item['last_seen']);
    timeago.setLocaleMessages('zh_CN', timeago.ZhCnMessages());

    return Container(
      color: Theme.of(context).backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    new ClipOval(
                      child: Image.network(
                        'https://img14.360buyimg.com/ceco/s300x300_jfs/t1/96894/2/8726/522292/5e07663aE99a1f3a7/50c33370b8c790a8.jpg!q70.jpg',
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        item['nickname'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      timeago.format(lastSeen),
                    )
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 42,
                    ),
                    Text("TA的单词：${item['words_count']}")
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

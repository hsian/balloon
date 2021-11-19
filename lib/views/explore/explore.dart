import 'package:balloon/components/body_builder.dart';
import 'package:balloon/util/enum/api_request_status.dart';
import 'package:flutter/material.dart';
import 'package:balloon/view_models/explore_provider.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
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
            automaticallyImplyLeading: false,
            centerTitle: false,
            title: Text(
              '浏览',
              style: TextStyle(fontSize: 18),
            ),
          ),
          body: BodyBuilder(
            apiRequestStatus: exploreProvider.apiRequestStatus,
            reload: () => exploreProvider.getExplores(),
            // child: RefreshIndicator(
            //   onRefresh: () =>
            //       exploreProvider.getExplores(exploreProvider.page),
            //   child: _buildBodyList(exploreProvider),
            // ),
            child: FutureBuilder(
              future: exploreProvider.getExplores(),
              builder: (context, snapshot) {
                return Container(
                  padding: EdgeInsets.only(bottom: 0),
                  child: EasyRefresh(
                    // enableControlFinishLoad: true,
                    header: ClassicalHeader(
                      refreshFailedText: '更新失败',
                      refreshReadyText: '开始更新',
                      refreshingText: '更新中...',
                      refreshedText: '更新完成',
                      refreshText: "开始更新",
                      showInfo: false,
                    ),
                    footer: ClassicalFooter(
                      loadFailedText: "请求错误",
                      loadReadyText: "开始请求",
                      loadingText: "请求数据中...",
                      loadText: "请求数据中...",
                      loadedText: "没有更多了",
                      noMoreText: "没有更多了",
                      showInfo: false,
                    ),
                    child: ListView.builder(
                      itemCount: exploreProvider.explores.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      itemBuilder: (BuildContext context, int index) {
                        return _buildStatsItem(exploreProvider.explores[index]);
                        // return WordCard(
                        //   scrolling: scrolling,
                        //   word: wordProvider.words[index],
                        // );
                      },
                    ),
                    onRefresh: () async {
                      exploreProvider.apiRequestStatus =
                          APIRequestStatus.loading;
                      return exploreProvider.getWordsByFirstPage();
                    },
                    onLoad: () async {
                      if (exploreProvider.hasMore) {
                        exploreProvider.page = exploreProvider.page + 1;
                        exploreProvider.apiRequestStatus =
                            APIRequestStatus.loading;
                        return exploreProvider.getExplores();
                      }
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  // _buildBodyList(exploreProvider) {
  //   return FutureBuilder(
  //     future: exploreProvider.getExplores(exploreProvider.page),
  //     builder: (context, snapshot) {
  //       return ListView.builder(
  //         itemCount: exploreProvider.explores.length,
  //         itemBuilder: (BuildContext context, int index) {
  //           return Column(
  //             children: [
  //               SizedBox(
  //                 height: 1,
  //               ),
  //               _buildStatsItem(exploreProvider.explores[index]),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

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

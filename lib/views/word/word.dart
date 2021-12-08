import 'dart:ui';

import 'package:balloon/components/body_builder.dart';
import 'package:balloon/util/enum/api_request_status.dart';
import 'package:dio/dio.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:balloon/view_models/word_provider.dart';
import 'package:flutter/material.dart';
import 'package:balloon/components/word_card.dart';
import 'package:provider/provider.dart';
import 'package:balloon/service/http_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Word extends StatefulWidget {
  @override
  _WordState createState() => _WordState();
}

class _WordState extends State<Word> {
  bool hiddenPannel = true;
  String inputValue = "";
  Duration delay = const Duration(seconds: 1);
  bool scrolling = false;
  Map searchResult = {
    "keyword": "",
    "explains": [],
  };

  TextEditingController inputController = TextEditingController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  initState() {
    super.initState();
    context.read<WordProvider>().getWords();
  }

  void inputChange(String value) {
    setState(() {
      inputValue = value.trim();
      if (inputValue.isEmpty) {
        hiddenPannel = true;
      }
    });
  }

  void togglePanel() {
    if (inputValue.isNotEmpty) {
      setState(() {
        hiddenPannel = false;
      });
    }
  }

  void inputCancel() {
    inputController.clear();
    setState(() {
      hiddenPannel = true;
      inputValue = "";
    });
  }

  void onSubmitted(String value, WordProvider wordProvider) async {
    togglePanel();
    // 获取关键词翻译结果
    var res = await wordProvider.getWordByKeyword(value);

    if (res is Map) {
      setState(() {
        searchResult = res;
      });
    }
  }

  // 添加新单词
  void addNewWord(WordProvider wordProvider) async {
    Response res = await wordProvider.postWordById(searchResult['id']);
    if (res.statusCode == 200) {
      EasyLoading.showSuccess(res.data['message']);
      inputCancel();

      // 重新获取第一页单词列表
      wordProvider.apiRequestStatus = APIRequestStatus.loading;
      wordProvider.getWordsByFirstPage();
      await wordProvider.getWords();
    }
  }

  // 删除单词
  removeWord(WordProvider wordProvider, int id, int index) async {
    Response res = await wordProvider.deleteWordById(id);

    if (res.statusCode == 200) {
      EasyLoading.showSuccess(res.data['message']);
      inputCancel();

      // 重新获取单词列表
      wordProvider.deleteWordByIndex(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (hiddenPannel == true) {
          return Future.value(true);
        } else {
          inputCancel();
          return Future.value(false);
        }
      },
      child: Consumer<WordProvider>(
        builder: (BuildContext context, WordProvider wordProvider, child) {
          return Scaffold(
            appBar: AppBar(
              actions: [],
            ),
            backgroundColor: Theme.of(context).dividerColor,
            body: BodyBuilder(
              apiRequestStatus: wordProvider.apiRequestStatus,
              reload: () => {},
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 60, top: 4),
                    child: SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      header: MaterialClassicHeader(
                        backgroundColor: Theme.of(context).accentColor,
                      ),
                      footer: ClassicFooter(
                        loadStyle: LoadStyle.ShowWhenLoading,
                        completeDuration: Duration(milliseconds: 500),
                        idleText: "请求完成",
                        failedText: "请求错误",
                        canLoadingText: "开始请求",
                        loadingText: "请求数据中...",
                        noDataText: "没有更多",
                      ),
                      controller: _refreshController,
                      onRefresh: () async {
                        wordProvider.apiRequestStatus =
                            APIRequestStatus.loading;
                        wordProvider.getWordsByFirstPage();
                        await wordProvider.getWords();
                        _refreshController.refreshCompleted();
                      },
                      onLoading: () async {
                        if (wordProvider.hasMore) {
                          wordProvider.page = wordProvider.page + 1;
                          wordProvider.apiRequestStatus =
                              APIRequestStatus.loading;
                          await wordProvider.getWords();
                          _refreshController.loadComplete();

                          if (wordProvider.hasMore == false) {
                            _refreshController.loadNoData();
                          }
                        }
                      },
                      child: _buildListView(wordProvider),
                    ),
                  ),
                  _buildSearchInput(wordProvider),
                  _buildSearchResult(),
                ],
              ),
            ),
          );
          //);
        },
      ),
    );
  }

  Widget _buildListView(WordProvider wordProvider) {
    if (wordProvider.words.length == 0) {
      return Container(
          padding: EdgeInsets.symmetric(vertical: 60),
          child: Text(
            "暂无单词，赶紧搜索添加吧！",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff999999),
            ),
          ));
    } else {
      return ListView.builder(
        itemCount: wordProvider.words.length,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        itemBuilder: (BuildContext context, int index) {
          return WordCard(
            scrolling: scrolling,
            word: wordProvider.words[index],
            onRemove: (id) {
              removeWord(wordProvider, id, index);
            },
          );
        },
      );
    }
  }

  Widget _buildSearchInput(WordProvider wordProvider) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
        height: 60,
        width: double.infinity,
        child: Row(
          children: [
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextField(
                controller: inputController,
                onChanged: inputChange,
                onSubmitted: (String value) {
                  onSubmitted(value, wordProvider);
                },
                decoration: InputDecoration(
                  hintText: "请输入内容",
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Offstage(
              offstage: inputValue.isEmpty,
              child: IconButton(
                onPressed: inputCancel,
                icon: Icon(
                  Icons.cancel,
                  color: Colors.grey,
                  size: 26,
                ),
              ),
            ),
            Offstage(
              offstage: hiddenPannel,
              child: IconButton(
                onPressed: () {
                  addNewWord(wordProvider);
                },
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).textTheme.headline6?.color,
                  size: 26,
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                onSubmitted(inputValue, wordProvider);
              },
              child: Icon(
                Icons.search,
                color: Colors.white,
                size: 18,
              ),
              backgroundColor: Theme.of(context).accentColor,
              elevation: 0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResult() {
    return Positioned(
      top: 0,
      bottom: 60,
      left: 0,
      width: MediaQuery.of(context).size.width,
      child: Offstage(
        offstage: hiddenPannel,
        child: Container(
          color: Theme.of(context).backgroundColor,
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: searchResult['keyword'],
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.headline4?.color),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              _buildExplains(searchResult['explains']),
            ],
          ),
        ),
      ),
    );
  }

  _buildExplains(List explains) {
    handleAudioPlay(item) async {
      final player = AudioPlayer();
      // 请求音频
      Response res = await HttpService.getAudioByKeyword(item.trim());

      if (res.statusCode == 200) {
        final data = res.data['data'];
        await player.setUrl('${HttpService.baseURL}/${data['us_audio']}');
        player.play();
      }
    }

    List<Widget> list = [];
    for (var item in explains) {
      list.add(
        Row(children: [
          Expanded(
            child: Text(
              item.trim(),
              softWrap: true,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).textTheme.headline5?.color,
              ),
            ),
          ),
          Container(
            width: 30,
            height: 24,
            child: IconButton(
              padding: EdgeInsets.all(0),
              iconSize: 13,
              onPressed: () {
                handleAudioPlay(item);
              },
              icon: Icon(
                FeatherIcons.volume2,
                color: Colors.blue,
                size: 16,
              ),
            ),
          )
        ]),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list,
    );
  }
}

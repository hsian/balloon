import 'dart:ui';

import 'package:balloon/components/body_builder.dart';
import 'package:balloon/view_models/word_provider.dart';
import 'package:flutter/material.dart';
import 'package:balloon/components/word_card.dart';
import 'package:provider/provider.dart';
import 'package:balloon/service/http_service.dart';

class Word extends StatefulWidget {
  @override
  _WordState createState() => _WordState();
}

class _WordState extends State<Word> {
  bool showPanel = true;
  String inputValue = "";
  Duration delay = const Duration(seconds: 1);
  bool scrolling = false;

  TextEditingController inputController = TextEditingController();

  void inputChange(String value) {
    setState(() {
      inputValue = value.trim();
      if (inputValue.isEmpty) {
        showPanel = true;
      }
    });
  }

  void togglePanel() {
    if (inputValue.isNotEmpty) {
      setState(() {
        showPanel = false;
      });
    }
  }

  void inputCancel() {
    inputController.clear();
    setState(() {
      showPanel = true;
      inputValue = "";
    });
  }

  void onSearch() {
    togglePanel();
  }

  void onSubmitted(String value) {
    togglePanel();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WordProvider>(
      builder: (BuildContext context, WordProvider wordProvider, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [],
          ),
          backgroundColor: Theme.of(context).dividerColor,
          body: BodyBuilder(
            apiRequestStatus: wordProvider.apiRequestStatus,
            reload: () => wordProvider.getWords(),
            child: FutureBuilder(
              future: wordProvider.getWords(),
              builder: (context, snapshot) {
                return Stack(
                  children: [
                    Container(
                      child: NotificationListener(
                        onNotification: (ScrollNotification notification) {
                          // if (notification is ScrollStartNotification) {
                          //   setState(() {
                          //     scrolling = true;
                          //   });
                          // } else
                          if (notification is ScrollUpdateNotification) {
                            setState(() {
                              scrolling = true;
                            });
                          }
                          return true;
                        },
                        child: ListView.builder(
                          itemCount: wordProvider.words.length,
                          shrinkWrap: true,
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                          itemBuilder: (BuildContext context, int index) {
                            return WordCard(
                              scrolling: scrolling,
                              word: wordProvider.words[index],
                            );
                          },
                        ),
                      ),
                    ),
                    _buildSearchInput(),
                    _buildSearchResult(),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchInput() {
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
                onSubmitted: onSubmitted,
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
              offstage: showPanel,
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).textTheme.headline6?.color,
                  size: 26,
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: onSearch,
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
        offstage: showPanel,
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
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                        text: "如客户是你的微信好友，可复制昵称到微信搜索，制昵称到微信搜索开启会话。",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).textTheme.headline4?.color),
                      ),
                      WidgetSpan(
                        child: SizedBox(
                          height: 23.0,
                          width: 23.0,
                          child: InkWell(
                            onTap: () {
                              print('---------------------');
                            },
                            child: Card(
                              child: Center(
                                child: Icon(
                                  Icons.volume_down,
                                  size: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ])),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "你好的意思",
                style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).textTheme.headline5?.color,
                    height: 1.6),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "[v] zhes",
                    style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).textTheme.headline5?.color,
                        height: 1.6),
                  ),
                  Text(
                    "[rr] 你好的意思",
                    style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).textTheme.headline5?.color,
                        height: 1.6),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

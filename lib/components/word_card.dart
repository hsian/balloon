import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import 'package:balloon/service/http_service.dart';
import 'package:just_audio/just_audio.dart';

class WordCard extends StatefulWidget {
  final word;

  WordCard({
    Key? key,
    required this.scrolling,
    required this.word,
  }) : super(key: key);

  final bool scrolling;

  @override
  _WordCardState createState() => _WordCardState(word);
}

class _WordCardState extends State<WordCard> {
  late bool _visible;
  final word;
  _WordCardState(this.word);

  @override
  void initState() {
    super.initState();
    _visible = true;
  }

  void _changeVisible(bool visible) {
    setState(() {
      _visible = visible;
    });
  }

  // @override
  // void didChangeDependencies() {
  //   // ignore: todo
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  //   print(this._visible);
  // }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('EEE, d MMM yyyy HH:mm:ss');
    final timestamp = formatter.parse(word['timestamp']);
    timeago.setLocaleMessages('zh_CN', timeago.ZhCnMessages());

    return GestureDetector(
      onTap: () {
        _changeVisible(true);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2.0),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          // borderRadius: BorderRadius.all(
          //   Radius.circular(4),
          // ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    word['keyword'],
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline4?.color),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  _buildExplains(word['explains']),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          timeago.format(timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).textTheme.headline6?.color,
                          ),
                        ),
                      ),
                      IconButton(
                        alignment: Alignment.centerRight,
                        onPressed: () {
                          _changeVisible(!_visible);
                        },
                        icon: Icon(
                          FeatherIcons.moreHorizontal,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                right: 35,
                bottom: 5,
                child: _buildActions(_visible),
              ),
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
      final value = await HttpService.getAudioByKeyword(item.trim());
      final data = value['data'];
      await player.setUrl('${HttpService.baseURL}/${data['us_audio']}');
      player.play();
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
              iconSize: 12,
              onPressed: () {
                handleAudioPlay(item);
              },
              icon: Icon(
                FeatherIcons.volume2,
                color: Colors.blue,
                size: 12,
              ),
            ),
          )
        ]),
      );
    }
    return Column(
      children: list,
    );
  }

  _buildActions(bool visible) {
    return Offstage(
      offstage: visible,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        // width: 90,
        height: 38,
        decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              child: IconButton(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                onPressed: () {},
                icon: Icon(
                  FeatherIcons.trash2,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

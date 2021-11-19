import 'dart:async';

import 'package:balloon/routes/router_tables.dart';
import 'package:flutter/material.dart';
import 'package:balloon/service/http_service.dart';
import 'package:provider/provider.dart';
import 'package:balloon/view_models/user_provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isButtonEnable = true;
  String buttonText = '发送验证码';
  int count = 60;
  // Timer ctimer;
  TextEditingController mController = TextEditingController();
  TextEditingController pController = TextEditingController();

  void _buttonClickListen() {
    setState(() {
      if (isButtonEnable) {
        isButtonEnable = false;
        _initTimer();
        // null 禁止点击
        return null;
      } else {
        return null;
      }
    });
  }

  void _initTimer() {
    new Timer.periodic(Duration(seconds: 1), (timer) {
      count--;
      setState(() {
        if (count == 0) {
          // ctimer = timer;
          timer.cancel();
          isButtonEnable = true;
          count = 60;
          buttonText = '发送验证码';
        } else {
          buttonText = '重新发送($count)';
        }
      });
    });
  }

  void login(userProvider) async {
    Map user = await HttpService.login();
    userProvider.setUser(user);
    // Navigator.pop(context);
    Navigator.pushNamed(context, RouterTables.mainPath);
  }

  @override
  void dispose() {
    // timer.cancel();
    mController.dispose();
    pController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (BuildContext context, UserProvider userProvider, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [],
          ),
          body: Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).padding.top + 30),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      textBaseline: TextBaseline.ideographic,
                      children: [
                        Text(
                          '手机号',
                          style: TextStyle(fontSize: 16),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: TextFormField(
                              cursorColor: Color(0xff666666),
                              maxLines: 1,
                              onSaved: (value) {},
                              controller: pController,
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                hintText: '请输入手机号码',
                                contentPadding:
                                    EdgeInsets.only(top: -5, bottom: 0),
                                hintStyle: TextStyle(
                                  color: Color(0xff999999),
                                  fontSize: 16,
                                ),
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                        )
                      ]),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    textBaseline: TextBaseline.ideographic,
                    children: [
                      Text(
                        '验证码',
                        style: TextStyle(fontSize: 16),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                          ),
                          child: TextFormField(
                            cursorColor: Color(0xff666666),
                            maxLines: 1,
                            onSaved: (value) {},
                            controller: mController,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              hintText: '请输入验证码',
                              contentPadding:
                                  EdgeInsets.only(top: -5, bottom: 0),
                              hintStyle: TextStyle(
                                color: Color(0xff999999),
                                fontSize: 16,
                              ),
                              alignLabelWithHint: true,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 120,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _buttonClickListen();
                            });
                          },
                          child: Text(
                            '$buttonText',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 45,
                  margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).accentColor,
                      ),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35))),
                    ),
                    onPressed: () {
                      login(userProvider);
                    },
                    child: Text(
                      '登录',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 45,
                  margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).backgroundColor,
                      ),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35))),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, RouterTables.mainPath);
                    },
                    child: Text(
                      '首页',
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).textTheme.headline6?.color),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

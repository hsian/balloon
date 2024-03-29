import 'package:balloon/routes/router_tables.dart';
import 'package:balloon/util/enum/api_request_status.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:balloon/view_models/user_provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final form = FormGroup({
    'username': FormControl<String>(validators: [
      Validators.required,
      Validators.pattern(r'^1[0-9]{10}$'),
    ]),
    'password': FormControl<String>(validators: [
      Validators.required,
    ]),
  });

  void _onPressed(UserProvider userProvider) async {
    if (form.valid) {
      userProvider.apiRequestStatus = APIRequestStatus.loading;
      Response res = await userProvider.login({...form.value});

      if (res.statusCode == 200) {
        final body = res.data;
        EasyLoading.showToast(body['message']);
        Navigator.pop(context);
      }
    } else {
      final username = form.control('username');
      final password = form.control('password');
      username.focus();
      username.unfocus();
      password.focus();
      password.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (BuildContext context, UserProvider userProvider, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [],
          ),
          body: SingleChildScrollView(
            child: Container(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top + 30),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ReactiveForm(
                  formGroup: this.form,
                  child: Column(
                    children: <Widget>[
                      ReactiveTextField(
                        decoration: InputDecoration(
                          hintText: '请输入手机号码',
                          contentPadding: EdgeInsets.only(top: -5, bottom: 0),
                          hintStyle: TextStyle(
                            color: Color(0xff999999),
                            fontSize: 16,
                          ),
                          alignLabelWithHint: true,
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                        strutStyle: StrutStyle(),
                        formControlName: 'username',
                        validationMessages: (control) => {
                          'required': '手机号码不能为空',
                          'pattern': "手机号码格式不正确",
                        },
                      ),
                      ReactiveTextField(
                        decoration: InputDecoration(
                          hintText: '请输入密码',
                          contentPadding: EdgeInsets.only(top: -5, bottom: 0),
                          hintStyle: TextStyle(
                            color: Color(0xff999999),
                            fontSize: 16,
                          ),
                          alignLabelWithHint: true,
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                        formControlName: 'password',
                        obscureText: true,
                        validationMessages: (control) => {
                          'required': '密码不能为空',
                        },
                      ),
                      Container(
                        width: double.infinity,
                        height: 45,
                        margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                        child: ReactiveFormConsumer(
                          builder: (context, form, child) {
                            return ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                                backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).accentColor,
                                ),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(35))),
                              ),
                              child: Text(
                                '登录',
                                style: TextStyle(fontSize: 16),
                              ),
                              onPressed: () => _onPressed(userProvider),
                            );
                          },
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
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35))),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, RouterTables.registerPath);
                          },
                          child: Text(
                            '注册',
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.color),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

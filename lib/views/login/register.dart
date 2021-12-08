import 'package:balloon/routes/router_tables.dart';
import 'package:balloon/util/enum/api_request_status.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:balloon/view_models/user_provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

ValidatorFunction _mustMatch(String controlName, String matchingControlName) {
  return (AbstractControl<dynamic> control) {
    final form = control as FormGroup;

    final formControl = form.control(controlName);
    final matchingFormControl = form.control(matchingControlName);

    if (formControl.value != matchingFormControl.value) {
      matchingFormControl.setErrors({'mustMatch': true});

      // force messages to show up as soon as possible
      matchingFormControl.markAsTouched();
    } else {
      matchingFormControl.removeError('mustMatch');
    }

    return null;
  };
}

class _RegisterState extends State<Register> {
  final form = FormGroup({
    'username': FormControl<String>(validators: [
      Validators.required,
      Validators.pattern(r'^1[0-9]{10}$'),
    ]),
    'nickname': FormControl<String>(validators: [
      Validators.required,
      Validators.pattern(r'^[\u4E00-\u9FA5A-Za-z0-9_]{2,6}$'),
    ]),
    'password': FormControl<String>(validators: [
      Validators.required,
      Validators.pattern(r'^[\w@#]{6,18}$'),
    ]),
    'passwordConfirmation': FormControl<String>(),
  }, validators: [
    _mustMatch('password', 'passwordConfirmation')
  ]);

  void _onPressed(UserProvider userProvider) async {
    if (form.valid) {
      userProvider.apiRequestStatus = APIRequestStatus.loading;
      Response res = await userProvider.register({...form.value});

      if (res.statusCode == 200) {
        EasyLoading.showToast(res.data['message']);
        Navigator.pop(context);
      }
    } else {
      final username = form.control('username');
      final nickname = form.control('nickname');
      final password = form.control('password');
      final passwordConfirmation = form.control('passwordConfirmation');
      username.focus();
      username.unfocus();
      nickname.focus();
      nickname.unfocus();
      password.focus();
      password.unfocus();
      passwordConfirmation.focus();
      passwordConfirmation.unfocus();
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
                          hintText: '请输入昵称',
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
                        formControlName: 'nickname',
                        validationMessages: (control) => {
                          'required': '昵称不能为空',
                          'pattern': "昵称必须是2~6位字符",
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
                          'pattern': "密码必须是6~18位字符",
                        },
                      ),
                      ReactiveTextField(
                        decoration: InputDecoration(
                          hintText: '请再次输入密码',
                          contentPadding: EdgeInsets.only(top: -5, bottom: 0),
                          hintStyle: TextStyle(
                            color: Color(0xff999999),
                            fontSize: 16,
                          ),
                          alignLabelWithHint: true,
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                        formControlName: 'passwordConfirmation',
                        obscureText: true,
                        validationMessages: (control) => {
                          'mustMatch': '两次密码不一致',
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
                                '注册',
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
                              context,
                              RouterTables.loginPath,
                            );
                          },
                          child: Text(
                            '登录',
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

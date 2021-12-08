import 'dart:convert';

import 'package:balloon/util/enum/api_request_status.dart';
import 'package:balloon/view_models/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:awesome_select/awesome_select.dart';
import 'package:provider/provider.dart';

class ChangeProfile extends StatefulWidget {
  @override
  _ChangeProfileState createState() => _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {
  List<XFile>? _imageFileList;
  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  Map<dynamic, dynamic> formData = {
    "nickname": "",
    "gender": 1,
  };
  // String nicknameValue = "";
  final ImagePicker _picker = ImagePicker();

  void _onImagePicker(ImageSource source,
      // ignore: unused_element
      {BuildContext? context,
      bool isMultiImage = false}) async {
    if (isMultiImage) {
      try {
        final pickedFileList = await _picker.pickMultiImage(
          maxWidth: 500,
          maxHeight: 500,
        );

        setState(() {
          _imageFileList = pickedFileList;
        });
      } catch (e) {
        print(e);
      }
    } else {
      try {
        final pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: 500,
          maxHeight: 500,
        );

        print(pickedFile);

        setState(() {
          _imageFile = pickedFile;
        });
      } catch (e) {
        print(e);
      }
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
          body: Column(
            children: [
              _buildAvatarPicker(userProvider),
              _buildNicknameInput(userProvider),
              _buildGenderChoice(userProvider),
              _buildSubmit(userProvider)
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatarPicker(UserProvider userProvider) {
    return Container(
      color: Theme.of(context).backgroundColor,
      padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
      child: InkWell(
        onTap: () {
          // _onImagePicker(ImageSource.gallery);
          EasyLoading.showToast("暂时无法更换头像");
        },
        child: Row(
          children: [
            Expanded(
              child: Text(
                "更换头像",
                style: TextStyle(fontSize: 16),
              ),
            ),
            new ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                "assets/images/default-avatar.png",
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNicknameInput(UserProvider userProvider) {
    final _controller = TextEditingController(
      text: userProvider.user['nickname'],
    );

    formData['nickname'] = userProvider.user['nickname'];

    void nicknameChange(String value) {
      formData['nickname'] = value.trim();
    }

    return Container(
      color: Theme.of(context).backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "昵称",
            style: TextStyle(fontSize: 16),
          ),
          Expanded(
            child: TextField(
              textAlign: TextAlign.right,
              controller: _controller,
              onChanged: nicknameChange,
              decoration: InputDecoration(
                  // errorText: '昵称不能为空',
                  hintText: "请输入内容",
                  border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderChoice(userProvider) {
    int gender = userProvider.user['gender'].toString() == 'true' ? 1 : 0;

    return Container(
      padding: EdgeInsets.only(left: 5),
      child: SmartSelect.single(
        title: "性别",
        selectedValue: gender, // 设置默认值
        choiceItems: [
          S2Choice(value: 1, title: "男"),
          S2Choice(value: 0, title: "女"),
        ],
        onChange: (state) {
          if (state.toString() == "男") {
            formData["gender"] = 1;
          } else {
            formData["gender"] = 0;
          }
        },
      ),
    );
  }

  Widget _buildSubmit(UserProvider userProvider) {
    return Container(
      width: double.infinity,
      height: 45,
      margin: EdgeInsets.only(top: 50, left: 20, right: 20),
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.all(
            Theme.of(context).accentColor,
          ),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(35))),
        ),
        onPressed: () async {
          // print(jsonEncode(formData));
          userProvider.apiRequestStatus = APIRequestStatus.loading;

          final res = await userProvider.updateUserProfile(formData);
          if (res.toString() != 'null' &&
              res.data['message'].toString().isNotEmpty) {
            EasyLoading.showSuccess(res.data['message']);
          }
        },
        child: Text(
          '确认修改',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

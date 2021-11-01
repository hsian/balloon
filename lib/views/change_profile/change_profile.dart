import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChangeProfile extends StatefulWidget {
  @override
  _ChangeProfileState createState() => _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {
  List<XFile>? _imageFileList;
  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  final ImagePicker _picker = ImagePicker();

  void _onImagePicker(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
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
    return Scaffold(
      appBar: AppBar(
        actions: [],
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).backgroundColor,
            padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
            child: InkWell(
              onTap: () {
                _onImagePicker(ImageSource.gallery);
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
                    child: Image.network(
                      'https://img14.360buyimg.com/ceco/s300x300_jfs/t1/96894/2/8726/522292/5e07663aE99a1f3a7/50c33370b8c790a8.jpg!q70.jpg',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 1,
          ),
          Container(
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
                    decoration: InputDecoration(
                        // errorText: '昵称不能为空',
                        hintText: "请输入内容",
                        border: InputBorder.none),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

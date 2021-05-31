import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:selling_pictures_platform/Widgets/customTextField.dart';
import 'package:selling_pictures_platform/DialogBox/errorDialog.dart';
import 'package:selling_pictures_platform/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:selling_pictures_platform/Config/config.dart';

import 'login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _cPasswordEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String userImageUrl = "";
  File _imageFile;
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                InkWell(
                  onTap: _selectAndPickImage,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 15.0,
                    ),
                    child: CircleAvatar(
                      radius: _screenWidth * 0.15,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          _imageFile == null ? null : FileImage(_imageFile),
                      child: _imageFile == null
                          ? Icon(
                              Icons.add_a_photo_outlined,
                              size: _screenWidth * 0.15,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _nameEditingController,
                        data: Icons.person,
                        hintText: "ユーザーネーム",
                        isObsecure: false,
                      ),
                      CustomTextField(
                        controller: _emailEditingController,
                        data: Icons.email,
                        hintText: "メールアドレス",
                        isObsecure: false,
                      ),
                      CustomTextField(
                        controller: _passwordEditingController,
                        data: FontAwesomeIcons.userLock,
                        hintText: "パスワード",
                        isObsecure: true,
                      ),
                      CustomTextField(
                        controller: _cPasswordEditingController,
                        data: FontAwesomeIcons.userLock,
                        hintText: "パスワード(確認用)",
                        isObsecure: true,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                  ),
                  onPressed: () {
                    uploadAndSaveImage();
                  },
                  child: Text(
                    "登録する",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //todo:!?
  Future<void> _selectAndPickImage() async {
    final picker = ImagePicker();
    PickedFile pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    //todo:わんちゃんこれで即時変換
    setState(
      () {
        _imageFile = File(pickedFile.path);
      },
    );
  }

  Future<void> uploadAndSaveImage() async {
    if (_nameEditingController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: "名前を入力してください。",
          );
        },
      );
    }
    if (_emailEditingController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: "メールアドレスを入力してください。",
          );
        },
      );
    }
    if (_passwordEditingController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: "パスワードを入力してください。",
          );
        },
      );
    }
    if (_imageFile == null) {
      showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: "画像を選択してください。",
          );
        },
      );
    } else {
      _passwordEditingController.text == _cPasswordEditingController.text
          ? _emailEditingController.text.isNotEmpty &&
                  _passwordEditingController.text.isNotEmpty &&
                  _cPasswordEditingController.text.isNotEmpty &&
                  _nameEditingController.text.isNotEmpty
              ? uploadToStorage()
              : displayDialog("未記入の項目があります。")
          : displayDialog("入力されたパスワードが正しくありません。");
    }
  }

  displayDialog(String msg) {
    showDialog(
      context: context,
      builder: (c) {
        return ErrorAlertDialog(
          message: msg,
        );
      },
    );
  }

  uploadToStorage() async {
    showDialog(
      context: context,
      builder: (c) {
        return LoadingAlertDialog(
          message: "登録中です。\n少々お待ちください。",
        );
      },
    );
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    final storage = FirebaseStorage.instance;
    Reference storageReference = storage.ref().child(imageFileName);
    UploadTask storageUploadTask = storageReference.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await storageUploadTask;
    await taskSnapshot.ref.getDownloadURL().then(
      (urlImage) {
        userImageUrl = urlImage;
        _registerUser();
      },
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async {
    User firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(
      email: _emailEditingController.text.trim(),
      password: _passwordEditingController.text.trim(),
    )
        .then(
      (auth) {
        firebaseUser = auth.user;
      },
    ).catchError(
      (error) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.toString(),
            );
          },
        );
      },
    );
    if (firebaseUser != null) {
      saveUserInfoToFirestore(firebaseUser).then(
        (
          value,
        ) {
          Navigator.pop(context);
          Route route = MaterialPageRoute(builder: (c) => StoreHome());
          Navigator.pushReplacement(context, route);
        },
      );
    }
  }

  Future saveUserInfoToFirestore(User fUser) async {
    FirebaseFirestore.instance.collection("users").doc(fUser.uid).set(
      {
        "uid": fUser.uid,
        "email": fUser.email,
        "name": _nameEditingController.text.trim(),
        "url": userImageUrl,
        "description": "",
        "TwitterURL": "",
        "InstagramURL": "",
        "FaceBookURL": "",
        EcommerceApp.userCartList: ["garbageValue"],
        EcommerceApp.userLikeList: ["garbageValue"],
      },
    );

    await EcommerceApp.sharedPreferences.setString(
      "uid",
      fUser.uid,
    );
    await EcommerceApp.sharedPreferences.setString(
      EcommerceApp.userEmail,
      fUser.email,
    );
    await EcommerceApp.sharedPreferences.setString(
      EcommerceApp.userName,
      _nameEditingController.text,
    );
    await EcommerceApp.sharedPreferences.setString(
      EcommerceApp.userAvatarUrl,
      userImageUrl,
    );
    await EcommerceApp.sharedPreferences.setString(
      "description",
      "",
    );
    await EcommerceApp.sharedPreferences.setString(
      "TwitterURL",
      "",
    );
    await EcommerceApp.sharedPreferences.setString(
      "InstagramURL",
      "",
    );
    await EcommerceApp.sharedPreferences.setString(
      "FaceBookURL",
      "",
    );
    await EcommerceApp.sharedPreferences.setStringList(
      EcommerceApp.userCartList,
      ["garbageValue"],
    );
    await EcommerceApp.sharedPreferences.setStringList(
      EcommerceApp.userLikeList,
      ["garbageValue"],
    );
  }
}

class ImageChange extends ChangeNotifier {
  File imageFile;
  setImage(File imageFile) {
    this.imageFile = imageFile;
    notifyListeners();
  }
}

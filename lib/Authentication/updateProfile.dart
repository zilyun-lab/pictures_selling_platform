import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:selling_pictures_platform/Models/user.dart';
import 'package:selling_pictures_platform/Widgets/customTextField.dart';
import 'package:selling_pictures_platform/DialogBox/errorDialog.dart';
import 'package:selling_pictures_platform/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:selling_pictures_platform/Config/config.dart';

import 'MyPage.dart';
import 'login.dart';

class ChangeProfile extends StatefulWidget {
  @override
  _ChangeProfileState createState() => _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {
  @override
  final TextEditingController _nameEditingController = TextEditingController(
      text: EcommerceApp.sharedPreferences
          .getString(EcommerceApp.userName)
          .trim()
          .toString());
  final TextEditingController _descriptionEditingController =
      TextEditingController(
          text: EcommerceApp.sharedPreferences
              .getString(EcommerceApp.userDescription)
              .trim()
              .toString());
  final TextEditingController _facebookEditingController =
      TextEditingController();
  final TextEditingController _instagramEditingController =
      TextEditingController();
  final TextEditingController _twitterEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String userImageUrl = "";
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

    // setState(() {
    //   userImageUrl = EcommerceApp.sharedPreferences
    //       .getString(EcommerceApp.userAvatarUrl)
    //       .toString();
    // });
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          title: Text(
            "LEEWAY",
            style: GoogleFonts.sortsMillGoudy(
              color: Colors.black,
              fontSize: 35,
              fontWeight: FontWeight.w100,
            ),
          ),
        ),
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
                      backgroundImage: _imageFile == null
                          ? NetworkImage(EcommerceApp.sharedPreferences
                              .getString(EcommerceApp.userAvatarUrl))
                          : FileImage(_imageFile),
                      child: _imageFile == null ? null : null,
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
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          obscureText: false,
                          controller:
                              _nameEditingController, //..text = nameData,

                          decoration: InputDecoration(
                              hintText: "ユーザーネーム",
                              prefixIcon: Icon(
                                Icons.perm_identity,
                                color: Colors.black,
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          obscureText: false,
                          controller:
                              _descriptionEditingController, //..text = descriptionData,
                          onChanged: (text) => {},
                          decoration: InputDecoration(
                              hintText: "自己紹介",
                              prefixIcon: Icon(
                                Icons.article_outlined,
                                color: Colors.black,
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          obscureText: false,
                          controller:
                              _facebookEditingController, //..text = descriptionData,
                          onChanged: (text) => {},
                          decoration: InputDecoration(
                              hintText: "FaceBook",
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0,
                                    bottom: 8.0,
                                    right: 8.0,
                                    left: 14),
                                child: FaIcon(
                                  FontAwesomeIcons.facebookSquare,
                                  color: Colors.black,
                                ),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          obscureText: false,
                          controller:
                              _twitterEditingController, //..text = descriptionData,
                          onChanged: (text) => {},
                          decoration: InputDecoration(
                              hintText: "Twitter",
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0,
                                    bottom: 8.0,
                                    right: 8.0,
                                    left: 14),
                                child: FaIcon(
                                  FontAwesomeIcons.twitterSquare,
                                  color: Colors.black,
                                ),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          obscureText: false,
                          controller:
                              _twitterEditingController, //..text = descriptionData,
                          onChanged: (text) => {},
                          decoration: InputDecoration(
                              hintText: "Instagram",
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0,
                                    bottom: 8.0,
                                    right: 8.0,
                                    left: 14),
                                child: FaIcon(
                                  FontAwesomeIcons.instagramSquare,
                                  color: Colors.black,
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                Wrap(children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                    onPressed: () {
                      Route route = MaterialPageRoute(
                        builder: (c) => MyPage(),
                      );
                      Navigator.pushReplacement(context, route);
                    },
                    child: Text(
                      "キャンセル",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                    onPressed: () {
                      print(_nameEditingController.text);
                      uploadAndSaveImage();
                    },
                    child: Text(
                      "  更新する  ",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ]),
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
      _nameEditingController.text.isNotEmpty
          ? uploadToStorage()
          : displayDialog("未記入の項目があります。");
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
        saveUserInfoToFirestore();
        Route route = MaterialPageRoute(builder: (c) => MyPage());
        Navigator.pushReplacement(context, route);
      },
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future saveUserInfoToFirestore() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(EcommerceApp.auth.currentUser.uid)
        .update(
      {
        "name": _nameEditingController.text.trim(),
        "url": userImageUrl,
        "description": _descriptionEditingController.text.trim(),
      },
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
      _descriptionEditingController.text,
    );
    Route route = MaterialPageRoute(builder: (c) => MyPage());
    Navigator.pushReplacement(context, route);
  }
}

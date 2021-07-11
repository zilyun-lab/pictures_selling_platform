import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:selling_pictures_platform/Authentication/NewUserSplashScreen.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Widgets/customTextField.dart';
import 'package:selling_pictures_platform/DialogBox/errorDialog.dart';
import 'package:selling_pictures_platform/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:selling_pictures_platform/Config/config.dart';

import 'SubmitBirthDay.dart';
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
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(children: [
        Container(
          color: HexColor("E67928"),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Image.asset(
                      "images/NoColor_horizontal.png",
                      height: 75,
                    ),
                    InkWell(
                      onTap: _selectAndPickImage,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 15.0,
                        ),
                        child: Container(
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(10),
                          //   color: Colors.white,
                          // ),
                          child: CircleAvatar(
                            radius: _screenWidth * 0.15,
                            backgroundColor: Colors.white,
                            backgroundImage: _imageFile == null
                                ? null
                                : FileImage(_imageFile),
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
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: _nameEditingController,
                              data: Icons.person,
                              hintText: "ユーザーネーム",
                              isObsecure: false,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 12,
                              ),
                              child: Divider(
                                thickness: 2,
                                color: Colors.white,
                              ),
                            ),
                            CustomTextField(
                              controller: _emailEditingController,
                              data: Icons.email,
                              hintText: "メールアドレス",
                              isObsecure: false,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 12,
                              ),
                              child: Divider(
                                thickness: 2,
                                color: Colors.white,
                              ),
                            ),
                            CustomTextField(
                              controller: _passwordEditingController,
                              data: FontAwesomeIcons.userLock,
                              hintText: "パスワード",
                              isObsecure: true,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 12,
                              ),
                              child: Divider(
                                thickness: 2,
                                color: Colors.white,
                              ),
                            ),
                            CustomTextField(
                              controller: _cPasswordEditingController,
                              data: FontAwesomeIcons.userLock,
                              hintText: "パスワード(確認用)",
                              isObsecure: true,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 12,
                              ),
                              child: Divider(
                                thickness: 2,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                      ),
                      child: ExpansionTile(
                        iconColor: Colors.white,
                        title: Text(
                          "会員登録の規約について",
                          style: TextStyle(color: Colors.white),
                        ),
                        children: [
                          Text(
                            "著作権　許諾の同意"
                            "\n\n本サービス及び本サービスのコンテンツの著作権及び商標権等の知的財産権（以下、「著作権等」といいます）は、当社又は著作権等を有する第三者に帰属するものとします。会員は、当社の書面による事前の承諾がある場合を除き、本サービスのコンテンツを当社又は著作権等を有する第三者の許諾を得ることなく使用することはできません。"
                            "\n会員は、本サービスサイトにデザイン画像をアップロードし、又は、商品データを入力した場合、当社に対して、当該商品データ等を、本サービスにおいて、以下の各号に掲げる方法のいずれかまたはすべてにより、当該商品データ等の全部または一部を無償で利用することを非独占的に許諾する。なお、許諾地域は日本を含むすべての国と地域とし、許諾期間は本サービスの利用契約の有効期間とします。"
                            "\n（１）インターネット、携帯電話その他情報通信ネットワーク、情報誌等含む任意の媒体を利用して、商品データ等の複製、頒布、自動公衆送信（送信可能化を含む）、修正及び改変を行うこと（本サービスサイトに掲載し閲覧させることを含む。）"
                            "\n（２）デザイン画像を商品素材に印刷、加工し、商品として製造すること、及び、これに付随する一切の行為"
                            "\n（３）前号に基づき製造した商品を、第６条第１項の委託を受けて購入者に販売すること"
                            "\n会員は、当社に対し、前項に定める許諾を、当社と提携若しくは協力関係にある第三者に対し再許諾することを許諾するものとします。"
                            "\n本サービスの利用契約の終了に伴い、本条第２項乃至第３項の許諾が終了する場合においても、当該許諾の終了以前に成立した売買契約に関する商品の製造及び販売を目的とする商品データ等の利用の許諾は有効なものとします。",
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                      ),
                      child: Container(
                        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: CheckboxListTile(
                          tileColor: Colors.white,
                          value: isChecked,
                          title: Text(
                            "規約を読んだ上で同意しますか？",
                            style: TextStyle(color: Colors.white),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          // チェックボックスを押下すると以下の処理が実行される
                          onChanged: (bool value) {
                            setState(() {
                              isChecked = value;
                            });
                          },
                        ),
                      ),
                    ),
                    isChecked
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                            ),
                            onPressed: () {
                              uploadAndSaveImage();
                            },
                            child: Text(
                              "登録する",
                              style: TextStyle(
                                color: HexColor("E67928"),
                              ),
                            ),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey,
                            ),
                            onPressed: () {},
                            child: Text(
                              "登録する",
                              style: TextStyle(
                                color: HexColor("E67928"),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 45.0, right: 45),
                      child: Divider(
                        color: Colors.white,
                        thickness: 2,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            type: PageTransitionType.leftToRightWithFade,
                            child: Login(),
                            inheritTheme: true,
                            ctx: context,
                            duration: Duration(
                              milliseconds: 500,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "ログイン",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  //todo:!?
  Future<void> _selectAndPickImage() async {
    final picker = ImagePicker();
    PickedFile pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

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
              message: "記入に誤りがあります。",
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
          Route route =
              MaterialPageRoute(builder: (c) => NewUserSplashScreen());
          Navigator.pushReplacement(context, route);
        },
      );
    }
  }

  Future saveUserInfoToFirestore(User fUser) async {
    FirebaseFirestore.instance.collection("users").doc(fUser.uid).set(
      {
        "isFreeze": false,
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
    FirebaseFirestore.instance
        .collection("users")
        .doc(fUser.uid)
        .collection("MyProceeds")
        .doc()
        .set(
      {
        "Proceeds": 0,
      },
    );
    FirebaseFirestore.instance
        .collection("users")
        .doc(fUser.uid)
        .collection("Followers")
        .doc()
        .set(
      {},
    );
    FirebaseFirestore.instance
        .collection("users")
        .doc(fUser.uid)
        .collection("BankAccount")
        .doc()
        .set(
      {"Submit": "false"},
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
      EcommerceApp.userLikeList,
      ["garbageValue"],
    );
  }
}

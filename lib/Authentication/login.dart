import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';

import 'package:selling_pictures_platform/Authentication/register.dart';
import 'package:selling_pictures_platform/Widgets/customTextField.dart';
import 'package:selling_pictures_platform/DialogBox/errorDialog.dart';
import 'package:selling_pictures_platform/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'package:selling_pictures_platform/Config/config.dart';

//以下、カラーコード使用時に必要なクラス

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new NetworkImage(
                "https://images.unsplash.com/photo-1605462398512-51e939d2d21d?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTh8fG9yYW5nZXxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=900&q=60",
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  //color: Colors.white.withOpacity(0.9),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Container(
                          child: Center(
                            child: Stack(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 3.0,
                                      left: 7,
                                    ),
                                    child: Text(
                                      "LEEWAY",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.8),
                                        fontSize: 50,
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 15,
                                    ),
                                    child: Text(
                                      "LEEWAY",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 50,
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 60.0, left: 20, right: 20),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: [
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
                              SizedBox(
                                height: 25,
                              ),
                              CustomTextField(
                                controller: _passwordEditingController,
                                data: Icons.lock,
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
                              SizedBox(
                                height: 40,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  //border: Border.all(),
                                ),
                                width: 175,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                  ),
                                  onPressed: () {
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
                                    if (_passwordEditingController
                                        .text.isEmpty) {
                                      showDialog(
                                        context: context,
                                        builder: (c) {
                                          return ErrorAlertDialog(
                                            message: "パスワードを入力してください。",
                                          );
                                        },
                                      );
                                    }
                                    _emailEditingController.text.isNotEmpty &&
                                            _passwordEditingController
                                                .text.isNotEmpty
                                        ? loginUser()
                                        : showDialog(
                                            context: context,
                                            builder: (c) {
                                              return ErrorAlertDialog(
                                                message: "未記入の項目があります。",
                                              );
                                            });
                                  },
                                  child: Text(
                                    "ログイン",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 18),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 80.0),
                                child: SizedBox(
                                  height: 25,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Route route = MaterialPageRoute(
                                    builder: (_) => Register(),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType
                                          .rightToLeftWithFade,
                                      child: Register(),
                                      inheritTheme: true,
                                      ctx: context,
                                      duration: Duration(
                                        milliseconds: 500,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  "新規登録",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  void loginUser() async {
    showDialog(
      context: context,
      builder: (c) {
        return LoadingAlertDialog(
          message: "ログイン中です。\n少々お待ちください。",
        );
      },
    );
    User firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
      email: _emailEditingController.text.trim(),
      password: _passwordEditingController.text.trim(),
    )
        .then(
      (authUser) {
        firebaseUser = authUser.user;
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
      readData(firebaseUser).then(
        (s) {
          Navigator.pop(context);
          Route route = MaterialPageRoute(
            builder: (c) => StoreHome(),
          );
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: StoreHome(),
              inheritTheme: true,
              ctx: context,
              duration: Duration(
                milliseconds: 1000,
              ),
            ),
          );
        },
      );
    }
  }

  Future readData(User fUser) async {
    FirebaseFirestore.instance.collection("users").doc(fUser.uid).get().then(
      (dataSnapshot) async {
        await EcommerceApp.sharedPreferences.setString(
          "uid",
          dataSnapshot.data()[EcommerceApp.userUID],
        );
        await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userEmail,
          dataSnapshot.data()[EcommerceApp.userEmail],
        );
        await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userName,
          dataSnapshot.data()[EcommerceApp.userName],
        );
        await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userAvatarUrl,
          dataSnapshot.data()[EcommerceApp.userAvatarUrl],
        );
        List<String> cartList =
            dataSnapshot.data()[EcommerceApp.userCartList].cast<String>();
        await EcommerceApp.sharedPreferences.setStringList(
          EcommerceApp.userCartList,
          cartList,
        );
      },
    );
  }
}

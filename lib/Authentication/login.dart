import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:selling_pictures_platform/Admin/adminLogin.dart';
import 'package:selling_pictures_platform/Authentication/register.dart';
import 'package:selling_pictures_platform/Authentication/registoration.dart';
import 'package:selling_pictures_platform/Widgets/customTextField.dart';
import 'package:selling_pictures_platform/DialogBox/errorDialog.dart';
import 'package:selling_pictures_platform/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'package:selling_pictures_platform/Config/config.dart';

//以下、カラーコード使用時に必要なクラス
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Container(
              //   alignment: Alignment.bottomCenter,
              //   child: Padding(
              //     padding: const EdgeInsets.all(50.0),
              //     child: ClipRRect(
              //       borderRadius: BorderRadius.circular(0.0),
              //       child: Image.network(
              //           "https://images.unsplash.com/photo-1618060931775-18ed14951776?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2100&q=80"),
              //     ),
              //   ),
              // child: Image.asset(
              //   "images/login.png",
              //   height: 240,
              //   width: 240,
              // ),
              // ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 25,
                  right: 8,
                  left: 8,
                  top: 30,
                ),
                child: Text(
                  "ログイン",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w100,
                      fontSize: 18),
                ),
              ),
              Form(
                key: _formkey,
                child: Column(
                  children: [
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
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
                        _emailEditingController.text.isNotEmpty &&
                                _passwordEditingController.text.isNotEmpty
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
            ],
          ),
        ),
      ),
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
          Navigator.pushReplacement(context, route);
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

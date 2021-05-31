import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:selling_pictures_platform/Admin/uploadItems.dart';
//import 'package:selling_pictures_platform/Authentication/authenication.dart';
import 'package:selling_pictures_platform/Widgets/customTextField.dart';
import 'package:selling_pictures_platform/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';

import 'adminResister.dart';

class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdminSignInScreen(),
    );
  }
}

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final TextEditingController _adminIDEditingController =
      TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    //_screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 8,
                right: 8,
                bottom: 25,
                top: 35,
              ),
              child: Text(
                "出品者としてログイン",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _adminIDEditingController,
                    data: FontAwesomeIcons.key,
                    hintText: "出品者ID",
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
                      if (_adminIDEditingController.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (c) {
                            return ErrorAlertDialog(
                              message: "出品者IDを入力してください。",
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
                      _adminIDEditingController.text.isNotEmpty &&
                              _passwordEditingController.text.isNotEmpty
                          ? loginAdmin()
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
                  Container(
                    height: 4.0,
                    width: _screenWidth * 0.8,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton.icon(
                    label: Text(
                      "新規登録",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminRegister(),
                      ),
                    ),
                    icon: Icon(
                      Icons.perm_identity_outlined,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 200,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  loginAdmin() {
    FirebaseFirestore.instance.collection("admins").get().then(
      (snapshot) {
        snapshot.docs.forEach(
          (result) {
            if (result.data()["id"] != _adminIDEditingController.text.trim()) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "出品者IDが違います",
                  ),
                ),
              );
            } else if (result.data()["password"] !=
                _adminIDEditingController.text.trim()) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "パスワードが違います",
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${result.data()["name"]} さん\nお帰りなさい"),
                ),
              );
              setState(
                () {
                  _adminIDEditingController.text = "";
                  _passwordEditingController.text = "";
                },
              );
              Route route = MaterialPageRoute(
                builder: (c) => UploadPage(),
              );
              Navigator.pushReplacement(
                context,
                route,
              );
            }
          },
        );
      },
    );
  }
}

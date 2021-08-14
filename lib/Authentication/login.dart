// Flutter imports:
// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';
// Project imports:
import 'package:selling_pictures_platform/Authentication/register.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/DialogBox/error_dialog.dart';
import 'package:selling_pictures_platform/DialogBox/loading_dialog.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:selling_pictures_platform/Widgets/custom_text_field.dart';

import '../main.dart';
import 'authe_error_handling.dart';
import 'password_reset.dart';

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
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Container(
              //color: Colors.white.withOpacity(0.9),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    'images/isColor_Horizontal.png',
                    height: 75,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 60, left: 20, right: 20),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _emailEditingController,
                            data: Icons.email,
                            hintText: 'メールアドレス',
                            isObsecure: false,
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //     left: 12,
                          //     right: 12,
                          //   ),
                          //   child: Divider(
                          //     thickness: 2,
                          //     color: Colors.white,
                          //   ),
                          // ),
                          const SizedBox(
                            height: 25,
                          ),
                          CustomTextField(
                            controller: _passwordEditingController,
                            data: Icons.lock,
                            hintText: 'パスワード',
                            isObsecure: true,
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //     left: 12,
                          //     right: 12,
                          //   ),
                          //   child: Divider(
                          //     thickness: 2,
                          //     color: Colors.white,
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 12,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.fade,
                                        child: const PasswordReset(),
                                        inheritTheme: true,
                                        ctx: context,
                                        duration: const Duration(
                                          milliseconds: 1000,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'パスワードをお忘れですか？',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: NeumorphicButton(
                                    style: NeumorphicStyle(color: bgColor),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType
                                              .rightToLeftWithFade,
                                          child: Register(),
                                          inheritTheme: true,
                                          ctx: context,
                                          duration: const Duration(
                                            milliseconds: 500,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Center(
                                      child: Text(
                                        '新規登録',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: mainColorOfLEEWAY),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: NeumorphicButton(
                                    style: NeumorphicStyle(color: bgColor),
                                    onPressed: () {
                                      if (_emailEditingController
                                          .text.isEmpty) {
                                        showDialog(
                                          context: context,
                                          builder: (c) {
                                            return const ErrorAlertDialog(
                                              message: 'メールアドレスを入力してください。',
                                            );
                                          },
                                        );
                                      }
                                      if (_passwordEditingController
                                          .text.isEmpty) {
                                        showDialog(
                                          context: context,
                                          builder: (c) {
                                            return const ErrorAlertDialog(
                                              message: 'パスワードを入力してください。',
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
                                                return const ErrorAlertDialog(
                                                  message: '未記入の項目があります。',
                                                );
                                              });
                                    },
                                    child: Center(
                                      child: Text(
                                        'ログイン',
                                        style: TextStyle(
                                            color: mainColorOfLEEWAY,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 80),
                            child: SizedBox(
                              height: 25,
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
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void loginUser() async {
    await showDialog(
      context: context,
      builder: (c) {
        return const LoadingAlertDialog(
          message: 'ログイン中です。\n少々お待ちください。',
        );
      },
    );
    User firebaseUser;
    final result = await signIn(
      email: _emailEditingController.text.trim(),
      password: _passwordEditingController.text.trim(),
    );
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
      (dynamic error) {
        final errorMessage =
            FirebaseAuthExceptionHandler.exceptionMessage(result);
        Navigator.pop(context);
        _showErrorDialog(context, errorMessage);
      },
    );
    if (firebaseUser != null) {
      await readData(firebaseUser).then(
        (s) {
          Navigator.pop(context);

          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: MainPage(),
              inheritTheme: true,
              ctx: context,
              duration: const Duration(
                milliseconds: 1000,
              ),
            ),
          );
        },
      );
    }
  }

  Future readData(User fUser) async {
    await FirebaseFirestore.instance.collection('users').doc(fUser.uid).get().then(
      (dataSnapshot) async {
        await EcommerceApp.sharedPreferences.setString(
          'uid',
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
        final List<String> cartList =
            dataSnapshot.data()[EcommerceApp.userCartList].cast<String>();
        await EcommerceApp.sharedPreferences.setStringList(
          EcommerceApp.userCartList,
          cartList,
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<FirebaseAuthResultStatus> signIn(
      {String email, String password}) async {
    FirebaseAuthResultStatus result;
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user == null) {
        // ユーザーが取得できなかったとき
        result = FirebaseAuthResultStatus.Undefined;
      } else {
        // ログイン成功時
        result = FirebaseAuthResultStatus.Successful;
      }
    } catch (error) {
      // エラー時
      result = FirebaseAuthExceptionHandler.handleException(error);
    }
    return result;
  }
}

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Project imports:
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 'success';
    } catch (error) {
      print(error);
      return error.code;
    }
  }
}

class PasswordReset extends StatefulWidget {
  const PasswordReset({Key key}) : super(key: key);

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: HexColor('E67928'),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'images/NoColor_Vertical.png',
                  height: 150,
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: TextFormField(
                    key: _formKey,
                    onChanged: (val) {
                      setState(() {
                        _email = _controller.text;
                      });
                    },
                    controller: _controller,
                  ),
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
                    onPressed: () async {
                      print(_email);
                      if (_email.isNotEmpty) {
                        final String _result =
                            await _auth.sendPasswordResetEmail(_email);

                        // 成功時は戻る

                        if (_result == 'success') {
                          await Fluttertoast.showToast(
                            msg: 'パスワード再設定用メールを送信しました。\nご確認の上再設定ください。',
                            backgroundColor: Colors.lightBlueAccent,
                          );
                          Navigator.pop(context);
                        } else if (_result == 'ERROR_INVALID_EMAIL') {
                          await Fluttertoast.showToast(
                            msg: '無効なメールアドレスです',
                            backgroundColor: Colors.red,
                          );
                        } else if (_result == 'ERROR_USER_NOT_FOUND') {
                          await Fluttertoast.showToast(
                            msg: 'メールアドレスが登録されていません',
                            backgroundColor: Colors.red,
                          );
                        } else {
                          await Fluttertoast.showToast(
                            msg: 'メール送信に失敗しました',
                            backgroundColor: Colors.red,
                          );
                        }
                      }
                    },
                    child: Text(
                      '送信する',
                      style: TextStyle(color: HexColor('E67928'), fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

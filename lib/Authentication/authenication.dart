import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:selling_pictures_platform/Admin/adminLogin.dart';
import 'login.dart';
import 'register.dart';
import 'package:selling_pictures_platform/Config/config.dart';

class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(74.0),
            child: AppBar(
              backgroundColor: Colors.white,
              bottom: new TabBar(
                labelStyle: TextStyle(fontSize: 15),
                labelColor: Colors.black,
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.login,
                      size: 20,
                    ),
                    text: "ログイン",
                  ),
                  Tab(
                    icon: Icon(
                      Icons.person_add,
                      size: 20,
                    ),
                    text: "新規登録",
                  ),
                ],
                indicatorColor: Colors.black,
                indicatorWeight: 2,
              ),
            ),
          ),
          body: Container(
            child: TabBarView(
              //todo:TabBarViewで選択したページを描画するためのページ
              children: [
                Login(),
                Register(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

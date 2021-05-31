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
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: new BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.white],
                  //colors: [HexColor("#f39800"), HexColor("#eb6101")],
                ),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                "LEEWAY",
                style: GoogleFonts.sortsMillGoudy(
                  color: Colors.black,
                  fontSize: 35,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
            centerTitle: true,
            bottom: new TabBar(
              labelColor: Colors.black,
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.login,
                  ),
                  text: "ログイン",
                ),
                Tab(
                  icon: Icon(
                    Icons.person_add,
                  ),
                  text: "新規登録",
                ),
              ],
              indicatorColor: Colors.black,
              indicatorWeight: 2.5,
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:selling_pictures_platform/Authentication/updateProfile.dart';
import 'package:selling_pictures_platform/Authentication/Notification.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'FAQ.dart';
import 'PrivacyPolicyEtc.dart';
import 'login.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("e5e2df"),
      floatingActionButton: myFloatingActionButton(
          "出品", bottomSheetItems(context), Icons.camera_alt_outlined),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Stack(
                children: [
                  Positioned(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 235,
                      decoration: BoxDecoration(
                        color: HexColor("#E67928"),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(90),
                          bottomRight: Radius.circular(90),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    top: 100,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 225,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    mySizedBox(55),
                                    EcommerceApp.auth.currentUser != null
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                  child: DefaultTextStyle(
                                                      style: TextStyle(
                                                          color: Colors
                                                              .lightBlueAccent,
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      child: new Text(EcommerceApp
                                                          .sharedPreferences
                                                          .getString(
                                                              EcommerceApp
                                                                  .userName)))),
                                              InkWell(
                                                child: Icon(
                                                  Icons.edit,
                                                  color: mainColorOfLEEWAY,
                                                ),
                                                onTap: () {
                                                  Route route =
                                                      MaterialPageRoute(
                                                    fullscreenDialog: true,
                                                    builder: (c) =>
                                                        ChangeProfile(),
                                                  );
                                                  Navigator.push(
                                                    context,
                                                    route,
                                                  );
                                                },
                                              )
                                            ],
                                          )
                                        : Text(
                                            "ゲスト",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                            StreamBuilder<QuerySnapshot>(
                                stream: EcommerceApp.firestore
                                    .collection("users")
                                    .doc(EcommerceApp.sharedPreferences
                                        .getString(EcommerceApp.userUID))
                                    .collection("MyProceeds")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  return snapshot.hasData
                                      ? Text(
                                          "${snapshot.data.docs[0]["Proceeds"].toString()} 円",
                                          style: TextStyle(
                                              color: mainColorOfLEEWAY,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 25),
                                        )
                                      : Text(
                                          "0 円",
                                          style: TextStyle(
                                              color: mainColorOfLEEWAY,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 25),
                                        );
                                }),
                            myPageSliderItems(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    top: 60,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25.0),
                        child: Image.network(
                          EcommerceApp.sharedPreferences.getString(
                            EcommerceApp.userAvatarUrl,
                          ),
                          fit: BoxFit.cover,
                          width: 125,
                          height: 100,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      width: 100,
                      height: 350,
                    ),
                  )
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    EcommerceApp.auth.currentUser != null
                        ? infoTile(context, Icons.notifications_active_outlined,
                            "お知らせ", UserNotification())
                        : Container(),
                    infoTile(context, Icons.privacy_tip_outlined, "利用規約等",
                        PrivacyPolicyPage()),
                    infoTile(context, Icons.question_answer_outlined, "よくある質問",
                        FAQ()),
                    EcommerceApp.auth.currentUser != null
                        ? Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 8.0, right: 8),
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: mainColorOfLEEWAY, width: 3),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: logOutWidget(context)),
                          )
                        : infoTile(context, Icons.login_outlined, "ログインまたは新規登録",
                            Login()),
                  ],
                ),
              ),
              mySizedBox(10)
            ],
          ),
        ),
      ),
    );
  }
}

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:selling_pictures_platform/Authentication/Notification.dart';
import 'package:selling_pictures_platform/Authentication/updateProfile.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'FAQ.dart';
import 'PrivacyPolicyEtc.dart';
import 'login.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  int proceeds = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      floatingActionButton: myFloatingActionButton(
          "出品", bottomSheetItems(context), Icons.camera_alt_outlined),
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(EcommerceApp.sharedPreferences
                    .getString(EcommerceApp.userUID))
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Container()
                  : Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Neumorphic(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w900,
                                          color: mainColorOfLEEWAY,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: "0",
                                          ),
                                          TextSpan(
                                            text: "円",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: mainColorOfLEEWAY,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: NeumorphicButton(
                                  style: NeumorphicStyle(
                                    boxShape: NeumorphicBoxShape.circle(),
                                  ),
                                  onPressed: () {
                                    Route route = MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (c) => ChangeProfile(),
                                    );
                                    Navigator.push(
                                      context,
                                      route,
                                    );
                                  },
                                  child: Icon(
                                    Icons.settings,
                                    color: mainColorOfLEEWAY,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Neumorphic(
                            style: NeumorphicStyle(
                                boxShape: NeumorphicBoxShape.circle(),
                                depth: 19,
                                intensity: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                width: 150,
                                height: 150,
                                child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                  EcommerceApp.sharedPreferences.getString(
                                    EcommerceApp.userAvatarUrl,
                                  ),
                                )),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Center(
                                child: DefaultTextStyle(
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    child: Center(
                                      child: new Text(
                                          snapshot.data.data()["name"]),
                                    ))),
                          ),
                          myPageSliderItems(context),
                          Column(
                            children: [
                              EcommerceApp.auth.currentUser != null
                                  ? infoTile(
                                      context,
                                      Icons.notifications_active_outlined,
                                      "お知らせ",
                                      UserNotification())
                                  : Container(),
                              infoTile(context, Icons.privacy_tip_outlined,
                                  "利用規約等", PrivacyPolicyPage()),
                              infoTile(context, Icons.question_answer_outlined,
                                  "よくある質問", FAQ()),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, left: 8.0, right: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Neumorphic(
                                    style: NeumorphicStyle(
                                      color: bgColor,
                                      shadowLightColor:
                                          Colors.black.withOpacity(0.4),
                                      shadowDarkColor:
                                          Colors.black.withOpacity(0.6),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        onTap: () {
                                          _openMailApp();
                                        },
                                        leading: Icon(Icons.mail_outline,
                                            color: HexColor("E67928")),
                                        title: Text(
                                          "お問い合わせ",
                                          style:
                                              TextStyle(color: Colors.black87),
                                        ),
                                        trailing: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 18,
                                          color: HexColor("E67928"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              EcommerceApp.auth.currentUser != null
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, left: 8.0, right: 8),
                                      child: logOutWidget(context),
                                    )
                                  : infoTile(context, Icons.login_outlined,
                                      "ログインまたは新規登録", Login()),
                            ],
                          ),
                        ],
                      ),
                    );
            }),
      ),
    );
  }

  void _openMailApp() async {
    final title = Uri.encodeComponent(
      '運営へのお問い合わせ',
    );
    final body = Uri.encodeComponent(
      '氏名： ${EcommerceApp.sharedPreferences.getString(
        EcommerceApp.userName,
      )}\nユーザーID：${EcommerceApp.sharedPreferences.getString(
        EcommerceApp.userUID,
      )}\nお問い合わせ内容：',
    );
    const mailAddress = 'contact@leewayjp.net';

    return _launchURL(
      'mailto:$mailAddress?subject=$title&body=$body',
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      final Error error = ArgumentError('Could not launch $url');
      throw error;
    }
  }
}

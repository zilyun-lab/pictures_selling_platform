import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:selling_pictures_platform/Address/addAddress.dart';
import 'package:selling_pictures_platform/Admin/MyUploadItems.dart';
import 'package:selling_pictures_platform/Admin/PostCard.dart';
import 'package:selling_pictures_platform/Admin/Sticker.dart';
import 'package:selling_pictures_platform/Admin/uploadItems.dart';
import 'package:selling_pictures_platform/Authentication/updateProfile.dart';
import 'package:selling_pictures_platform/Authentication/Notification.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Models/item.dart';
import 'package:selling_pictures_platform/Orders/TransactionPage.dart';
import 'package:selling_pictures_platform/Orders/myOrders.dart';
import 'package:selling_pictures_platform/Store/product_page.dart';

import 'dart:io';

import '../main.dart';
import 'FAQ.dart';
import 'PrivacyPolicyEtc.dart';
import 'ProceedsRequests.dart';
import 'login.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final mainColor = HexColor("E67928");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("e5e2df"),
      floatingActionButton: Container(
        width: 100,
        height: 100,
        child: FloatingActionButton(
          backgroundColor: mainColor,
          onPressed: () {
            showModalBottomSheet<int>(
                context: context,
                builder: (BuildContext context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "何を出品しますか？",
                          style: TextStyle(
                              color: mainColor, fontWeight: FontWeight.bold),
                        ),
                      )),
                      ListTile(
                        title: Text(
                          '原画',
                          style: TextStyle(color: mainColor),
                        ),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => OriginalUploadPage())),
                      ),
                      ListTile(
                        title: Text(
                          'ステッカー',
                          style: TextStyle(color: mainColor),
                        ),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (c) => Sticker())),
                      ),
                      ListTile(
                        title: Text(
                          'ポストカード',
                          style: TextStyle(color: mainColor),
                        ),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (c) => PostCard())),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                });
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text("出品"),
                Icon(
                  Icons.camera_alt_outlined,
                  size: 50,
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50.0))),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    color: HexColor("#E67928"),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(90),
                      bottomRight: Radius.circular(90),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.105,
                  left: MediaQuery.of(context).size.width * 0.04,
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 65,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 30.0,
                                    ),
                                    child: Flexible(
                                      child: Row(
                                        children: [
                                          EcommerceApp.auth.currentUser != null
                                              ? Center(
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
                                                                  .userName))))
                                              : Text(
                                                  "ゲスト",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 10.0,
                                            ),
                                            child: EcommerceApp
                                                        .auth.currentUser !=
                                                    null
                                                ? InkWell(
                                                    child: Icon(
                                                      Icons.edit,
                                                      color: mainColor,
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
                                                : null,
                                          ),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                      ),
                                    ),
                                  ),
                                  EcommerceApp.auth.currentUser != null
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.yenSign,
                                              color: mainColor,
                                              size: 15,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            StreamBuilder<QuerySnapshot>(
                                              stream: EcommerceApp.firestore
                                                  .collection(EcommerceApp
                                                      .collectionUser)
                                                  .doc(EcommerceApp
                                                      .sharedPreferences
                                                      .getString(
                                                          EcommerceApp.userUID))
                                                  .collection("MyProceeds")
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                return Text(
                                                  snapshot.data
                                                          .docs[0]["Proceeds"]
                                                          .toString() +
                                                      " 円",
                                                  style: TextStyle(
                                                      color: mainColor,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 20),
                                                );
                                              },
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  CarouselSlider(
                                    items: [
                                      sliderItem(
                                        context,
                                        "売り上げ申請",
                                        ProceedsRequests(),
                                        Icons.atm_outlined,
                                      ),
                                      sliderItem(
                                        context,
                                        "出品履歴",
                                        MyUploadItems(),
                                        Icons.brush,
                                      ),
                                      sliderItem(
                                        context,
                                        "お届け先の追加",
                                        AddAddress(),
                                        Icons.add_location_alt_outlined,
                                      ),
                                      sliderItem(
                                        context,
                                        "購入履歴",
                                        MyOrders(),
                                        Icons.history_outlined,
                                      ),
                                      sliderItem(
                                        context,
                                        "取引履歴",
                                        TransactionPage(),
                                        Icons.history_outlined,
                                      ),
                                    ],
                                    options: CarouselOptions(
                                      height: 80,
                                      viewportFraction: 0.3,
                                      enableInfiniteScroll: true,
                                      enlargeCenterPage: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.08,
                  left: MediaQuery.of(context).size.width * 0.325,
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
                Container(
                  //color: Colors.black.withOpacity(0.7),
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.50,
                )
              ],
            ),
            Column(
              children: [
                EcommerceApp.auth.currentUser != null
                    ? infoTile(context, Icons.notifications_active_outlined,
                        "お知らせ", UserNotification())
                    : Container(),
                infoTile(context, Icons.privacy_tip_outlined, "利用規約等",
                    PrivacyPolicyPage()),
                infoTile(
                    context, Icons.question_answer_outlined, "よくある質問", FAQ()),
                EcommerceApp.auth.currentUser != null
                    ? Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 8.0, right: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: mainColor, width: 3),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            onTap: () {
                              EcommerceApp.auth.signOut().then(
                                (c) {
                                  Route route = MaterialPageRoute(
                                    builder: (c) => Login(),
                                  );
                                  Navigator.push(
                                    context,
                                    route,
                                  );
                                },
                              );
                            },
                            leading:
                                Icon(Icons.login_outlined, color: mainColor),
                            title: Text(
                              "ログアウト",
                              style: TextStyle(color: mainColor),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: mainColor,
                            ),
                          ),
                        ),
                      )
                    : infoTile(
                        context, Icons.login_outlined, "ログインまたは新規登録", Login()),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

Widget infoTile(
    BuildContext context, IconData icon, String title, Widget func) {
  return Padding(
    padding: const EdgeInsets.only(top: 5, left: 8.0, right: 8),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: HexColor("E67928"), width: 3),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: ListTile(
        onTap: () {
          Route route = MaterialPageRoute(
            builder: (c) => func,
          );
          Navigator.push(
            context,
            route,
          );
        },
        leading: Icon(icon, color: HexColor("E67928")),
        title: Text(
          title,
          style: TextStyle(color: HexColor("E67928")),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: HexColor("E67928"),
        ),
      ),
    ),
  );
}

Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  Color iconColor = Colors.grey;
  final _screenSize = MediaQuery.of(context).size;

  return InkWell(
    onTap: () {
      Route route = MaterialPageRoute(
        builder: (c) => ProductPage(
          thumbnailURL: model.thumbnailUrl,
          shortInfo: model.shortInfo,
          longDescription: model.longDescription,
          price: model.price,
          attribute: model.attribute,
          postBy: model.postBy,
          Stock: model.Stock,
          id: model.id,
        ),
      );
      Navigator.pushReplacement(
        context,
        route,
      );
    },
    splashColor: Colors.black,
    child: Expanded(
      child: Padding(
        padding: const EdgeInsets.all(
          5.0,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 1.0),
                      child: Image.network(
                        model.thumbnailUrl,
                        width: 140,
                        height: MediaQuery.of(context).size.height * 0.15,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Align(
                        alignment: Alignment(-1, 1.0),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text("¥" + (model.price).toString()),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget sliderItem(
    BuildContext context, String title, Widget page, IconData icon) {
  return InkWell(
    onTap: () {
      EcommerceApp.auth.currentUser != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => page,
              ))
          : null;
    },
    child: Container(
      width: 80,
      decoration: BoxDecoration(
        color: HexColor("#E67928"),
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 45,
              ),
              Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w100,
                    fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

changeProfile() {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _cPasswordEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String userImageUrl = "";
  File _imageFile;
}

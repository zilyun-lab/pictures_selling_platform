import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:selling_pictures_platform/Address/addAddress.dart';
import 'package:selling_pictures_platform/Admin/MyUploadItems.dart';
import 'package:selling_pictures_platform/Admin/uploadItems.dart';
import 'package:selling_pictures_platform/Authentication/updateProfile.dart';
import 'package:selling_pictures_platform/Authentication/Notification.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Counters/cartitemcounter.dart';
import 'package:selling_pictures_platform/Models/item.dart';
import 'package:selling_pictures_platform/Orders/myOrders.dart';
import 'package:selling_pictures_platform/Store/like.dart';
import 'package:selling_pictures_platform/Store/product_page.dart';
import 'package:selling_pictures_platform/Store/storehome.dart';
import 'package:selling_pictures_platform/Widgets/customAppBar.dart';
import 'package:selling_pictures_platform/Widgets/loadingWidget.dart';
import 'package:selling_pictures_platform/Widgets/myDrawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("e5e2df"),
        floatingActionButton: Container(
          width: 100,
          height: 100,
          child: FloatingActionButton(
            backgroundColor: mainColor,
            onPressed: () {
              Route route = MaterialPageRoute(
                builder: (c) => UploadPage(),
              );
              Navigator.pushReplacement(context, route);
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
              Card(
                color: HexColor("e5e2df").withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Material(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            (80),
                          ),
                        ),
                        elevation: 8,
                        child: Container(
                          height: 80,
                          width: 80,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              EcommerceApp.sharedPreferences.getString(
                                EcommerceApp.userAvatarUrl,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, bottom: 35),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                EcommerceApp.auth.currentUser != null
                                    ? Text(
                                        EcommerceApp.sharedPreferences
                                            .getString(EcommerceApp.userName),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                        ),
                                      )
                                    : Text(
                                        "ゲスト",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, bottom: 35),
                            child: EcommerceApp.auth.currentUser != null
                                ? InkWell(
                                    child: Icon(Icons.edit),
                                    onTap: () {
                                      Route route = MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (c) => ChangeProfile(),
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
                      ),
                      SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        EcommerceApp.auth.currentUser != null
                            ? Card(
                                color: HexColor("e5e2df").withOpacity(0.9),
                                child: ListTile(
                                  leading: FaIcon(FontAwesomeIcons.yenSign),
                                  title: Text(EcommerceApp.sharedPreferences
                                          .getString(EcommerceApp.userName) +
                                      " さんの売上金"),
                                  trailing: StreamBuilder<QuerySnapshot>(
                                    stream: EcommerceApp.firestore
                                        .collection(EcommerceApp.collectionUser)
                                        .doc(EcommerceApp.sharedPreferences
                                            .getString(EcommerceApp.userUID))
                                        .collection("MyProceeds")
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      return Text(
                                        snapshot.data.docs[0]["Proceeds"]
                                                .toString() +
                                            "円",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            : Container(),
                        EcommerceApp.auth.currentUser != null
                            ? Card(
                                color: HexColor("e5e2df").withOpacity(0.9),
                                child: ListTile(
                                  onTap: () {
                                    Route route = MaterialPageRoute(
                                      builder: (c) => ProceedsRequests(),
                                    );
                                    Navigator.push(
                                      context,
                                      route,
                                    );
                                  },
                                  leading: Icon(Icons.atm_outlined),
                                  title: Text("売上振り込み申請"),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  EcommerceApp.auth.currentUser != null
                      ? Card(
                          color: HexColor("e5e2df").withOpacity(0.6),
                          child: ListTile(
                            onTap: () {
                              Route route = MaterialPageRoute(
                                builder: (c) => MyUploadItems(),
                              );
                              Navigator.push(
                                context,
                                route,
                              );
                            },
                            leading: Icon(Icons.brush),
                            title: Text("出品した商品"),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                            ),
                          ),
                        )
                      : Container(),
                  EcommerceApp.auth.currentUser != null
                      ? Card(
                          color: HexColor("e5e2df").withOpacity(0.6),
                          child: ListTile(
                            onTap: () {
                              Route route = MaterialPageRoute(
                                builder: (c) => UserNotification(),
                              );
                              Navigator.push(
                                context,
                                route,
                              );
                            },
                            leading: Icon(Icons.notifications_active_outlined),
                            title: Text("お知らせ"),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                            ),
                          ),
                        )
                      : Container(),
                  EcommerceApp.auth.currentUser != null
                      ? Card(
                          color: HexColor("e5e2df").withOpacity(0.6),
                          child: ListTile(
                            onTap: () {
                              Route route = MaterialPageRoute(
                                builder: (c) => AddAddress(),
                              );
                              Navigator.push(
                                context,
                                route,
                              );
                            },
                            leading: Icon(Icons.add_location_alt_outlined),
                            title: Text("お届け先の追加"),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                            ),
                          ),
                        )
                      : Container(),
                  EcommerceApp.auth.currentUser != null
                      ? Card(
                          color: HexColor("e5e2df").withOpacity(0.6),
                          child: ListTile(
                            onTap: () {
                              Route route = MaterialPageRoute(
                                builder: (c) => MyOrders(),
                              );
                              Navigator.push(
                                context,
                                route,
                              );
                            },
                            leading: Icon(Icons.history_outlined),
                            title: Text("注文履歴"),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                            ),
                          ),
                        )
                      : Container(),
                  Card(
                    color: HexColor("e5e2df").withOpacity(0.6),
                    child: ListTile(
                      onTap: () {
                        Route route = MaterialPageRoute(
                          builder: (c) => PrivacyPolicyPage(),
                        );
                        Navigator.push(
                          context,
                          route,
                        );
                      },
                      leading: Icon(Icons.privacy_tip_outlined),
                      title: Text("利用規約等"),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                      ),
                    ),
                  ),
                  EcommerceApp.auth.currentUser != null
                      ? Card(
                          color: HexColor("e5e2df").withOpacity(0.6),
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
                            leading: Icon(Icons.login_outlined),
                            title: Text(
                              "ログアウト",
                              //style: TextStyle(color: Colors.pink),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                            ),
                          ),
                        )
                      : Card(
                          color: HexColor("e5e2df").withOpacity(0.6),
                          child: ListTile(
                            onTap: () {
                              Route route = MaterialPageRoute(
                                builder: (c) => Login(),
                              );
                              Navigator.pushReplacement(
                                context,
                                route,
                              );
                            },
                            leading: Icon(Icons.login_outlined),
                            title: Text(
                              "ログインまたは新規登録",
                              //style: TextStyle(color: Colors.pink),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                            ),
                          ),
                        ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
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

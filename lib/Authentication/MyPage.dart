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

import 'authenication.dart';
import 'login.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("e5e2df"),
        floatingActionButton: Container(
          width: 100,
          height: 100,
          child: FloatingActionButton(
            backgroundColor: HexColor("E5694E"),
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
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Route route = MaterialPageRoute(
                  builder: (c) => StoreHome(),
                );
                Navigator.pushReplacement(context, route);
              },
              icon: Icon(
                Icons.home_outlined,
                size: 35,
              )),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Center(
            child: InkWell(
              onTap: () {
                Route route = MaterialPageRoute(
                  builder: (c) => StoreHome(),
                );
                Navigator.pushReplacement(context, route);
              },
              child: Text(
                "LEEWAY",
                style: GoogleFonts.sortsMillGoudy(
                  color: Colors.black,
                  fontSize: 35,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.favorite_outline_outlined,
                    color: Colors.black,
                    size: 35,
                  ),
                  onPressed: () {
                    Route route = MaterialPageRoute(builder: (c) => LikePage());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Positioned(
                  child: Stack(
                    children: [
                      Icon(
                        Icons.brightness_1,
                        size: 20,
                        color: Colors.black,
                      ),
                      //todo: アイテムカウントの可視化
                      Positioned(
                        top: 3,
                        bottom: 4,
                        left: 6,
                        child: Consumer<LikeItemCounter>(
                          builder: (context, counter, _) {
                            return Text(
                              (EcommerceApp.sharedPreferences
                                          .getStringList(
                                              EcommerceApp.userLikeList)
                                          .length -
                                      1)
                                  .toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
        // drawer: MyDrawer(),
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
                                const EdgeInsets.only(left: 5.0, bottom: 35),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  EcommerceApp.sharedPreferences
                                      .getString(EcommerceApp.userName),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.start,
                                //     children: [
                                //       StreamBuilder<DocumentSnapshot>(
                                //         stream: EcommerceApp.firestore
                                //             .collection(
                                //                 EcommerceApp.collectionUser)
                                //             .doc(FirebaseAuth
                                //                 .instance.currentUser.uid)
                                //             .snapshots(),
                                //         builder: (context, dataSnapshot) {
                                //           return !dataSnapshot.hasData
                                //               ? Center(
                                //                   child: circularProgress(),
                                //                 )
                                //               : Padding(
                                //                   padding:
                                //                       const EdgeInsets.only(
                                //                           left: 10.0, top: 1),
                                //                   child: InkWell(
                                //                     onTap: () {
                                //                       launch(dataSnapshot
                                //                           .data["InstagramURL"]
                                //                           .toString());
                                //                     },
                                //                     child: FaIcon(
                                //                       FontAwesomeIcons
                                //                           .instagram,
                                //                       size: 40,
                                //                     ),
                                //                   ));
                                //         },
                                //       ),
                                //       StreamBuilder<DocumentSnapshot>(
                                //         stream: EcommerceApp.firestore
                                //             .collection(
                                //                 EcommerceApp.collectionUser)
                                //             .doc(FirebaseAuth
                                //                 .instance.currentUser.uid)
                                //             .snapshots(),
                                //         builder: (context, dataSnapshot) {
                                //           return !dataSnapshot.hasData
                                //               ? Center(
                                //                   child: circularProgress(),
                                //                 )
                                //               : Padding(
                                //                   padding:
                                //                       const EdgeInsets.only(
                                //                           left: 10.0, top: 1),
                                //                   child: InkWell(
                                //                     onTap: () {
                                //                       launch(dataSnapshot
                                //                           .data["TwitterURL"]
                                //                           .toString());
                                //                     },
                                //                     child: FaIcon(
                                //                       FontAwesomeIcons.twitter,
                                //                       size: 40,
                                //                     ),
                                //                   ));
                                //         },
                                //       ),
                                //       StreamBuilder<DocumentSnapshot>(
                                //         stream: EcommerceApp.firestore
                                //             .collection(
                                //                 EcommerceApp.collectionUser)
                                //             .doc(FirebaseAuth
                                //                 .instance.currentUser.uid)
                                //             .snapshots(),
                                //         builder: (context, dataSnapshot) {
                                //           return !dataSnapshot.hasData
                                //               ? Center(
                                //                   child: circularProgress(),
                                //                 )
                                //               : Padding(
                                //                   padding:
                                //                       const EdgeInsets.only(
                                //                           left: 10.0, top: 1),
                                //                   child: InkWell(
                                //                     onTap: () {
                                //                       launch(dataSnapshot
                                //                           .data["FaceBookURL"]
                                //                           .toString());
                                //                     },
                                //                     child: FaIcon(
                                //                       FontAwesomeIcons.facebook,
                                //                       size: 40,
                                //                     ),
                                //                   ));
                                //         },
                                //       ),
                                //       // InkWell(
                                //       //   onTap: () {
                                //       //     launch('https://www.facebook.com');
                                //       //   },
                                //       //   child: FaIcon(
                                //       //     FontAwesomeIcons.facebook,
                                //       //     size: 40,
                                //       //   ),
                                //       // )
                                //     ],
                                //   ),
                                // ),
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
                                      Navigator.pushReplacement(
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
              //Padding(
              //padding: EdgeInsets.only(left: 15.0),
              //child: Row(
              //children: [
              // Text(
              //   "自己紹介",
              //   style: TextStyle(
              //       fontSize: 18, color: Colors.black.withOpacity(0.7)),
              // ),
              //],
              //),
              //),
              // Container(
              //   width: MediaQuery.of(context).size.width * 0.95,
              //   decoration:
              //       BoxDecoration(border: Border.all(color: Colors.black)),
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 5.0, bottom: 50),
              //     child: Row(
              //       children: [
              //         Flexible(
              //           child: Padding(
              //             padding: const EdgeInsets.all(5.0),
              //             child: StreamBuilder<DocumentSnapshot>(
              //               stream: EcommerceApp.firestore
              //                   .collection(EcommerceApp.collectionUser)
              //                   .doc(FirebaseAuth.instance.currentUser.uid)
              //                   .snapshots(),
              //               builder: (context, dataSnapshot) {
              //                 return !dataSnapshot.hasData
              //                     ? Center(
              //                         child: circularProgress(),
              //                       )
              //                     : Padding(
              //                         padding: const EdgeInsets.only(
              //                             left: 10.0, top: 1),
              //                         child: Text(
              //                           dataSnapshot.data["description"]
              //                               .toString(),
              //                           style: TextStyle(fontSize: 25),
              //                         ),
              //                       );
              //               },
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Card(
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
                                  snapshot.data.docs[0]["Proceeds"].toString() +
                                      "円",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Card(
                          color: HexColor("e5e2df").withOpacity(0.9),
                          child: ListTile(
                            // onTap: () {
                            //   Route route = MaterialPageRoute(
                            //     builder: (c) => MyUploadItems(),
                            //   );
                            //   Navigator.pushReplacement(
                            //     context,
                            //     route,
                            //   );
                            // },
                            leading: Icon(Icons.atm_outlined),
                            title: Text("売上振り込み申請"),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    color: HexColor("e5e2df").withOpacity(0.6),
                    child: ListTile(
                      onTap: () {
                        Route route = MaterialPageRoute(
                          builder: (c) => MyUploadItems(),
                        );
                        Navigator.pushReplacement(
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
                  ),
                  Card(
                    color: HexColor("e5e2df").withOpacity(0.6),
                    child: ListTile(
                      onTap: () {
                        Route route = MaterialPageRoute(
                          builder: (c) => UserNotification(),
                        );
                        Navigator.pushReplacement(
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
                  ),
                  Card(
                    color: HexColor("e5e2df").withOpacity(0.6),
                    child: ListTile(
                      onTap: () {
                        Route route = MaterialPageRoute(
                          builder: (c) => AddAddress(),
                        );
                        Navigator.pushReplacement(
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
                  ),
                  Card(
                    color: HexColor("e5e2df").withOpacity(0.6),
                    child: ListTile(
                      onTap: () {
                        Route route = MaterialPageRoute(
                          builder: (c) => MyOrders(),
                        );
                        Navigator.pushReplacement(
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
                  ),
                  Card(
                    color: HexColor("e5e2df").withOpacity(0.6),
                    child: ListTile(
                      onTap: () {
                        EcommerceApp.auth.signOut().then(
                          (c) {
                            Route route = MaterialPageRoute(
                              builder: (c) => Login(),
                            );
                            Navigator.pushReplacement(
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
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 5.0, bottom: 8),
              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     height: MediaQuery.of(context).size.height * 0.05,
              //     child: StreamBuilder<QuerySnapshot>(
              //       stream: EcommerceApp.firestore
              //           .collection(EcommerceApp.collectionUser)
              //           .doc(EcommerceApp.sharedPreferences
              //               .getString(EcommerceApp.userUID))
              //           .collection("MyUploadItems")
              //           .snapshots(),
              //       builder: (context, dataSnapshot) {
              //         return !dataSnapshot.hasData
              //             ? Center(
              //                 child: circularProgress(),
              //               )
              //             : Padding(
              //                 padding:
              //                     const EdgeInsets.only(left: 10.0, top: 1),
              //                 child: Text(
              //                   "出品数：" +
              //                       dataSnapshot.data.docs.length.toString(),
              //                   style: TextStyle(fontSize: 25),
              //                 ),
              //               );
              //       },
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 5.0),
              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     height: MediaQuery.of(context).size.height,
              //     child: StreamBuilder<QuerySnapshot>(
              //         stream: EcommerceApp.firestore
              //             .collection(EcommerceApp.collectionUser)
              //             .doc(EcommerceApp.sharedPreferences
              //                 .getString(EcommerceApp.userUID))
              //             .collection("MyUploadItems")
              //             .orderBy(
              //               "publishedDate",
              //               descending: true,
              //             )
              //             .snapshots(),
              //         builder: (context, dataSnapshot) {
              //           return !dataSnapshot.hasData
              //               ? Center(
              //                   child: circularProgress(),
              //                 )
              //               : GridView.builder(
              //                   itemCount: dataSnapshot.data.docs.length,
              //                   gridDelegate:
              //                       SliverGridDelegateWithFixedCrossAxisCount(
              //                     crossAxisCount: 3,
              //                   ),
              //                   itemBuilder: (context, index) {
              //                     ItemModel model = ItemModel.fromJson(
              //                       dataSnapshot.data.docs[index].data(),
              //                     );
              //                     return sourceInfoForMain(model, context);
              //                   },
              //                 );
              //         }),
              //   ),
              // ),
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
        builder: (c) => ProductPage(itemModel: model),
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
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: removeCartFunction == null
                  //       ? Padding(
                  //           padding: const EdgeInsets.only(top: 8.0),
                  //           child: IconButton(
                  //             icon: Icon(
                  //               Icons.add_shopping_cart,
                  //               color: Colors.black,
                  //             ),
                  //             onPressed: () {
                  //               checkItemInCart(model.shortInfo, context);
                  //             },
                  //           ),
                  //         )
                  //       : IconButton(
                  //           onPressed: () {
                  //             removeCartFunction();
                  //             Route route = MaterialPageRoute(
                  //               builder: (_) => StoreHome(),
                  //             );
                  //             Navigator.pushReplacement(
                  //               context,
                  //               route,
                  //             );
                  //           },
                  //           icon: Icon(Icons.delete),
                  //           color: Colors.black,
                  //         ),
                  // ),
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
